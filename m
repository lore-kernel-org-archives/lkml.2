Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0DZJsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:48:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63610 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0DZJsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QdGIpusYntQ28bpr/VjYS/fn0SOa6xJw5+EhyoTDkRyZZbPBJcZbIGcXKPbupHmcdu
         O+DnQmxetqcl9ADOvVdlvp7lSCc/ZLUHDfALboV4Ut6AIpMpQ/BD6Qa3VhbLImtF6S2+
         WN4dsFgA1yFKNzmy8RWDiabU/j9TJR9xExoKk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004231129530.1777-100000@iolanthe.rowland.org>
References: <g2lfb5cec441004230805m8fc1251ekeb936837349b6e16@mail.gmail.com>
	 <Pine.LNX.4.44L0.1004231129530.1777-100000@iolanthe.rowland.org>
Date: Mon, 26 Apr 2010 11:48:04 +0200
Message-ID: <k2ufb5cec441004260248h30d52f76j211a841a16783251@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] Mass storage gadget: Handle eject request
From: Chouteau Fabien <fabien.chouteau@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 5:36 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Fri, 23 Apr 2010, Chouteau Fabien wrote:
>
> > > > + * When a LUN receive an "eject" SCSI request (Start/Stop Unit),
> > > > + * if the LUN is removable, the backing file is released to simulate
> > > > + * ejection.
> > > > + * The "eject" state of a LUN is available in the "ejected" file of the
> > > > + * LUN's sysfs directory (see above). The "eject" state is only updated
> > > > + * by SCSI request, not by user ejection.
> > >
> > > What's the reason for that?  With a real removable device, like a CD
> > > player, it doesn't make any difference whether the medium was ejected
> > > because of a SCSI command or because I pressed the "eject" button.
> > >
> > > I just don't see any point in keeping track of the two actions
> > > separately, since they end up having the same final result.
> > >
> >
> > By user ejection, I mean send an empty line in the "file" sysfs entry.
> > The Start/Stop request is an action from the USB host side, user
> > ejection is from the USB device side, for me it's two different
> > events.
> > Maybe my comment is not clear about this point.
>
> No; it's clear enough and I understood what you meant.  It's true that
> they are two different events, but they have the same end result.
>
> > I use a FAT disk image as LUN file, users can put some files in the
> > "fake" disk and then eject it. When I get the ejected signal, I mount
> > the disk image on loop device and perform operations on the user's
> > files.
> > So I want to know when users eject the disk and only when users do.
> >
> > I still can use the LUN ejection from device side to disable the mass
> > storage device, and in this case I don't want to mount the disk and
> > search for user's files.
>
> Why not?  Isn't it possible that the user put some files there before
> the device-side eject happened?
>
> What happens if the user and the device both try to eject the medium at
> approximately the same time?  Which event occurs first will be purely
> random chance.  That means there's a 50% probability you will end up
> doing the wrong thing.
>
> No, I think you need to do the same thing whenever an eject occurs, or
> else find a better criterion for deciding what to do.

You're right, I can do the same thing for both ejection.
I'm going to resend the patch without the "eject" sysfs entry.


--
Fabien Chouteau
EPITA GISTR 2010
