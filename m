Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2AUPEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:04:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab2AUPD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:03:58 -0500
Date: Sat, 21 Jan 2012 10:02:51 -0500
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        devel@driverdev.osuosl.org, techeng <dzshen@gmail.com>, clyu@citiz.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add Winbond WB528SD Secure Digital (SD) card reader
 driver
Message-ID: <20120121150251.GA28340@suse.de>
References: <4F1A98F5.3080402@freemail.hu>
 <20120121125153.GB18829@suse.de>
 <4F1AD195.70305@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F1AD195.70305@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 03:54:13PM +0100, Németh Márton wrote:
> Hi Greg,
> 
> thanks for your response and your questions, I think it will help my
> work very much.
> 
> Greg KH wrote:
> > On Sat, Jan 21, 2012 at 11:52:37AM +0100, Németh Márton wrote:
> >> From: Márton Németh <nm127@freemail.hu>
> >>
> >> This driver version of Winbond WB528SD can detect mechanical card
> >> presence only. The information is provided through sysfs.
> > 
> > How is it provided through sysfs?  Is this done in a standard way?  If
> > not, why not?
> 
> I used device_create_file()/device_remove_file() and DEVICE_ATTR(), in
> that sense it is standard. I'm not sure, however, that you a referring
> to this, rather referring to the standard way how other SD card readers
> provide the card presence information to the user space, right?

Yes, the latter is what matters.

> To tell you the truth, I could not find an other PCI card driver which
> I can take as an example, I would need some help on this.

I don't think that any other device does this, as it properly hooks up
the block device for the card inserted, which generates the needed
userspace notifications.

So please don't create a non-standard way of determining if a card is
present or not, you are creating a kernel/user API here that needs to be
preserved if it gets into the kernel tree.

> > Why is this driver submitted to the staging tree?  What is keeping it
> > from going into the "real" portion of the kernel for other card readers?
> 
> Interrupt handling, read, write and connecting the driver upwards to the
> block subsystem, I guess.
> 
> > We need a TODO file for what is needed to get it moved out of staging.
> 
> I can create one, no problem.
> 
> > Oh, and it needs to do a bit more than just detect a card to be useful,
> > right?  How about read/write to it?
> 
> Sure. My intention was to get feedback for my work as early as possible.
> I reached a state where a minimal level of functionality is available:
> the mechanical SD card presence is available for userspace programs.

What could a userspace program do with this information?

> The read/write access will be a bit more difficult, I guess because I
> currently don't have access to the register programming reference of
> this device, I can use the trial-and-error method, for example.

Yeah, doing this type of work is hard, and I understand your want to get
it into the tree at this early stage.  However, we really need something
that actually works, otherwise people are going to be very confused when
they see their device bound to this driver, yet nothing works.

So I think we need to wait until it can handle the block device handling
logic first, before we can add it to the kernel tree, even in the
staging directory.

Good luck with this effort, it is not easy at all.

greg k-h
