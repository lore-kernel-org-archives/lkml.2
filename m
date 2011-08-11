Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1HKPt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:49:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39246 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750928Ab1HKPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:49:56 -0400
Date: Thu, 11 Aug 2011 11:49:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <libusb-devel@lists.sourceforge.net>,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        <hector@marcansoft.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <20110811162530.5d1c6455@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.1108111145360.1958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, Alan Cox wrote:

> Actually there are more issues than that - you've also got to worry about
> a security/permission model, and that is hard to get right, especially if
> you are not very careful that anything that can be retrieved which might
> violate the security model (eg the last frame on the capture) has been
> blanked before handover etc.

As far as I can tell, these same security issues exist today.  I don't 
see them getting any worse than they are now.

> And applications that are touching both video (even indirectly) and still
> camera may get surprise deadlocks if they accidentally reference both the
> still and video device even via some library or service.

No, not deadlocks.  Just -EBUSY errors.

> > > Well, a user program can assume that the kernel driver left the device
> > > in a clean state.  The reverse isn't always true, however -- it's one
> 
> Not it cannot - the user program doesn't know
> 
> a) if the kernel driver has ever been loaded
> b) the values the kernel driver leaves set (and those will change no
> doubt at times)
> c) if the camera has been plugged and unplugged and not yet had the
> kernel driver loaded

That's true.  The program can't assume that a kernel driver was ever 
bound to the device; all it can assume is that _if_ a kernel driver was 
bound then it left the device in a sane state -- whatever "sane" might 
mean in this context.

> To me it sounds like a recipe for disaster. For those tiny number of
> devices involved just use V4L and if need be some small V4L tweaks to
> handle still mode. In most cases the interface is basically identical and
> I'd bet much of the code is identical too.

I'm not against moving the whole thing into the kernel.  I'm just
pointing out that an easier-to-code-up solution will accomplish much
the same result.

Alan Stern

