Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0DWPgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:36:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58971 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755598Ab0DWPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:36:50 -0400
Date: Fri, 23 Apr 2010 11:36:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Chouteau Fabien <fabien.chouteau@gmail.com>
cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 2/2] Mass storage gadget: Handle eject request
In-Reply-To: <g2lfb5cec441004230805m8fc1251ekeb936837349b6e16@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004231129530.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Chouteau Fabien wrote:

> > > + * When a LUN receive an "eject" SCSI request (Start/Stop Unit),
> > > + * if the LUN is removable, the backing file is released to simulate
> > > + * ejection.
> > > + * The "eject" state of a LUN is available in the "ejected" file of the
> > > + * LUN's sysfs directory (see above). The "eject" state is only updated
> > > + * by SCSI request, not by user ejection.
> >
> > What's the reason for that?  With a real removable device, like a CD
> > player, it doesn't make any difference whether the medium was ejected
> > because of a SCSI command or because I pressed the "eject" button.
> >
> > I just don't see any point in keeping track of the two actions
> > separately, since they end up having the same final result.
> >
> 
> By user ejection, I mean send an empty line in the "file" sysfs entry.
> The Start/Stop request is an action from the USB host side, user
> ejection is from the USB device side, for me it's two different
> events.
> Maybe my comment is not clear about this point.

No; it's clear enough and I understood what you meant.  It's true that 
they are two different events, but they have the same end result.

> I use a FAT disk image as LUN file, users can put some files in the
> "fake" disk and then eject it. When I get the ejected signal, I mount
> the disk image on loop device and perform operations on the user's
> files.
> So I want to know when users eject the disk and only when users do.
> 
> I still can use the LUN ejection from device side to disable the mass
> storage device, and in this case I don't want to mount the disk and
> search for user's files.

Why not?  Isn't it possible that the user put some files there before 
the device-side eject happened?

What happens if the user and the device both try to eject the medium at
approximately the same time?  Which event occurs first will be purely
random chance.  That means there's a 50% probability you will end up
doing the wrong thing.

No, I think you need to do the same thing whenever an eject occurs, or
else find a better criterion for deciding what to do.

Alan Stern

