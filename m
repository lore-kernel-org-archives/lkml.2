Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1GCBQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 21:16:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1GCBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 21:16:34 -0400
Date: Sun, 3 Jul 2011 03:16:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl,
        linux-usb@vger.kernel.org
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110703011630.GA15637@one.firstfloor.org>
References: <20110702181501.GN23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107021559250.16190-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021559250.16190-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > if (trace_scsi && dev->type == &scsi_dev_type &&
> >      trace_scsi_dev[0] == 0 || !strcmp(dev_name(dev), trace_scsi_dev))) {
> > 	dev_printk ...
> 
> These extra puts could be coming from deep inside the device-model
> core, where they operate directly on the underlying kobject instead of
> going through put_device().  For example, removal of sysfs symlinks
> could have this effect.

Ok I could move it to kobject with some complications (need a real
back trace then)

> On my system, at least, the scsi_device's refcount dropped to 0 at the 
> right time.  That wasn't the problem.  The NULL pointer occurs because 
> the request_queue is used after the scsi_device has been removed from 
> visibility; among other things, __scsi_remove_device() sets 
> sdev->request_queue->queuedata to NULL.
> 
> As the comment says, this causes the request function to reject all I/O 
> requests -- but not before trying to dereference the NULL pointer!

Your explanation completely contradicts what James wrote earlier.

Maybe it's good if you guys come up with a common avenue of debugging
before I try further.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
