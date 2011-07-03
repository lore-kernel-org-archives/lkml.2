Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1GCP34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 11:29:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37866 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755832Ab1GCP3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 11:29:51 -0400
Date: Sun, 3 Jul 2011 11:29:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <axboe@kernel.dk>, <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
In-Reply-To: <20110703011630.GA15637@one.firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1107031121440.28411-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011, Andi Kleen wrote:

> > On my system, at least, the scsi_device's refcount dropped to 0 at the 
> > right time.  That wasn't the problem.  The NULL pointer occurs because 
> > the request_queue is used after the scsi_device has been removed from 
> > visibility; among other things, __scsi_remove_device() sets 
> > sdev->request_queue->queuedata to NULL.
> > 
> > As the comment says, this causes the request function to reject all I/O 
> > requests -- but not before trying to dereference the NULL pointer!
> 
> Your explanation completely contradicts what James wrote earlier.

Yes, it does.  I'm claiming that James was on a wrong track or looking
in the wrong direction.

> Maybe it's good if you guys come up with a common avenue of debugging
> before I try further.

It will be interesting to hear what James has to say about all this...

> > Would you like to try this patch to see if it fixes the problem?  As I 
> > said before, I'm not certain it's the best thing to do, but it worked 
> > on my system.
> 
> I can try next week.

Okay.

> Is this patch likely to fix the RCU stall?

I have no idea.  All I know about this RCU stall is what you wrote 
before, i.e., that it happened once.  No debugging information or 
anything else.  However if it happens again with the patch in place, 
we'll be in a good position to figure the cause and fix it.

Alan Stern

