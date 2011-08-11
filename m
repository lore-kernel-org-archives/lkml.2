Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1HKT51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:57:27 -0400
Received: from banach.math.auburn.edu ([131.204.45.3]:37809 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1HKT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:57:25 -0400
Date: Thu, 11 Aug 2011 15:01:30 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <Pine.LNX.4.44L0.1108111145360.1958-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1108111235400.27040@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108111145360.1958-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Aug 2011, Alan Stern wrote:

> On Thu, 11 Aug 2011, Alan Cox wrote:
> 
> > Actually there are more issues than that - you've also got to worry about
> > a security/permission model, and that is hard to get right, especially if
> > you are not very careful that anything that can be retrieved which might
> > violate the security model (eg the last frame on the capture) has been
> > blanked before handover etc.
> 
> As far as I can tell, these same security issues exist today.  I don't 
> see them getting any worse than they are now.
> 
> > And applications that are touching both video (even indirectly) and still
> > camera may get surprise deadlocks if they accidentally reference both the
> > still and video device even via some library or service.
> 
> No, not deadlocks.  Just -EBUSY errors.
> 
> > > > Well, a user program can assume that the kernel driver left the device
> > > > in a clean state.  The reverse isn't always true, however -- it's one
> > 
> > Not it cannot - the user program doesn't know
> > 
> > a) if the kernel driver has ever been loaded
> > b) the values the kernel driver leaves set (and those will change no
> > doubt at times)
> > c) if the camera has been plugged and unplugged and not yet had the
> > kernel driver loaded
> 
> That's true.  The program can't assume that a kernel driver was ever 
> bound to the device; all it can assume is that _if_ a kernel driver was 
> bound then it left the device in a sane state -- whatever "sane" might 
> mean in this context.
> 
> > To me it sounds like a recipe for disaster. For those tiny number of
> > devices involved just use V4L and if need be some small V4L tweaks to
> > handle still mode. In most cases the interface is basically identical and
> > I'd bet much of the code is identical too.
> 
> I'm not against moving the whole thing into the kernel.  I'm just
> pointing out that an easier-to-code-up solution will accomplish much
> the same result.
> 
> Alan Stern
> 

Alan,

As I said, I am agnostic, though leaning in the direction that Hans de 
Goede is pointing. What he says about a single control mechanism seems to 
make a lot of sense. If you can come up with an outline of the "easier to 
code" solution, that would be interesting, though.

I assume you are also going to be in Vancouver? If you will be there on 
Monday, then Hans and I are already planning to meet and discuss. 

BTW, as to using V4L with "tweaks" to handle still mode, it would probably 
be more difficult than is imagined. For, though the operations required to 
process still images and webcam frames are in principle similar, the 
priorities and constraints are too different. Therefore, my understanding 
is that the libgphoto2 image processing routines, not the libv4l image 
processing routines, would still be used for still images.

Theodore Kilgore
