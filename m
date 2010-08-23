Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0HWTRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:17:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39898 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753222Ab0HWTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:17:41 -0400
Date: Mon, 23 Aug 2010 15:17:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Runtime PM and the block layer
Message-ID: <Pine.LNX.4.44L0.1008231501390.1601-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens:

I want to implement runtime power management for the SCSI sd driver.  
The idea is that the device should automatically be suspended after a
certain amount of time spent idle.

The basic outline is simple enough.  If the device is in low power when
a request arrives, delay handling the request until the device can be
brought back to high power.  When a request completes and the request
queue is empty, schedule a runtime-suspend for the appropriate time in
the future.

The difficulty is that I don't know the right way these things should
interact with the request-queue management.  A request can be deferred
by making the prep_req_fn return BLKPREP_DEFER, right?  But then what
happens to the request and to the queue?  How does the runtime-resume
routine tell the block layer that the deferred request should be
restarted?

How does this all relate to the queue being stopped or plugged?

Another thing: The runtime-resume routine needs to send its own
commands to the device (to spin up a drive, for example).  These
commands must be sent before anything on the request queue, and they
must be handled right away even though the normal requests on the queue
are still deferred.

What's the right way to do all this?

Thanks,

Alan Stern

