Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1GCQGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 12:06:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49211 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755954Ab1GCQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 12:06:41 -0400
Date: Sun, 3 Jul 2011 12:06:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <axboe@kernel.dk>, <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
In-Reply-To: <Pine.LNX.4.44L0.1107031121440.28411-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1107031201200.28411-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011, Alan Stern wrote:

> > Your explanation completely contradicts what James wrote earlier.
> 
> Yes, it does.  I'm claiming that James was on a wrong track or looking
> in the wrong direction.

To amplify: James wrote:

> Right, that wouldn't work.  The sdev in question comes from
> request_queue->queuedata.  That only goes to null when the last
> reference to the sdev has been released.  So the root cause is something
> in sd holding a reference to sdev without actually getting an additional
> refcount.

The third sentence is clearly wrong, because queuedata is set to NULL
when sdev is removed from visibility, not when the last reference to it
has been released, i.e., in __scsi_remove_device() rather than
scsi_device_dev_release_usercontext().

Maybe this means the assignment to queuedata should be moved.  I don't 
know; unlike James, I'm not an expert on the details of the SCSI stack.

Alan Stern

