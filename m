Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1E3HoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:44:12 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54859 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066Ab1E3HoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:44:10 -0400
X-Sasl-enc: N8RdFkuZhxltSNz0X4gjaz5sdUzlPAdE1KEO7YSfDWlh 1306741449
Date: Mon, 30 May 2011 15:45:08 +0800
From: Greg KH <greg@kroah.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Message-ID: <20110530074508.GB7806@kroah.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
 <20110527073302.GA16178@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:26:48AM -0700, Xiangliang Yu wrote:
> >> +What:          /sys/devices/pci/<devices>/<dev>/host/scsi_host/host/interrupt_coalescing
> >> +Date:          May 2011
> >> +Kernel Version:        2.6.39
> 
> >2.6.39 was released already, is this file in that release?
> Yes.

How, doesn't your patch below implement that option?  How can it already
be in the .39 kernel?

> >> +Contact:       yuxiangl@marvell.com
> >> +Description:   Determines the maximum time the 88SE94XX waits after the occurrence of a
> >> +               Command Done before generating an interrupt.The maximum number of the 
> >> +               variable is less than 0x10000.
> 
> >Why would a user, or anyone else, ever want to be able to change this?
> Because different platform can get better performance by setting different value

Then you need to document _how_ to do this tuning, and why someone would
want to, and lots of other stuff.  Don't just blindly let userspace
change a value that they know nothing about.

> >Why wouldn't this just be something that the driver handles
> >automagically so the user never has to worry about it at all?
> As for now, driver can't do it. The value need to be test, and get the best.

Why don't you test it and set it to the proper value now?  What would
change in a user's system that require this to be changed?  Size of the
machine?  Number of disks?  Something else?

It really should be automatic, people do not ever want to have to
manually tune their machines anymore they should be smart enough to
determine the load on them and make the changes without any user needing
to do it for them.

thanks,

greg k-h
