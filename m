Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1GCUjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:39:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56348 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1GCUjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:39:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Jul 2011 22:37:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110703223757.0e2b5ee0@stein>
In-Reply-To: <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
References: <1309609482.2554.8.camel@mulgrave>
	<Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 02 Alan Stern wrote:
> Also, I have no idea why this shows up with USB drives but not other 
> SCSI transports.  A fluke of timing?

A while ago I frequently observed oopses at removal of a FireWire
CompactFlash card reader (an sd device which exposes itself as device with
removable medium).  At that time I wasn't motivated to track down whether
the bug resided in the block or SCSI or firewire subsystem.  The bug was
apparently triggered because hald was polling the device like crazy for
media changes, and that polling coincided with device hot unplug.

Furthermore, FireWire CD-ROM removal never has been an exactly glitch-free
experience because the SCSI stack occasionally went on to issue command
retries for many minutes after device removal a.k.a. DID_NO_CONNECT.  I
don't remember crashes during FireWire CD-ROM removal, but it has been a
while that I last used CD-ROM drives.

I might test the card reader and a CD-ROM later next week on 3.0-rc6 if I
find the time and the issue hadn't been resolved by then.  I don't have
hald anymore, but there are certainly other ways to force accesses during
device shutdown.
-- 
Stefan Richter
-=====-==-== -=== ---==
http://arcgraph.de/sr/
