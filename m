Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1HJQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:09:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53080 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752449Ab1HJQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:09:12 -0400
Date: Wed, 10 Aug 2011 12:09:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
cc: Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
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
In-Reply-To: <alpine.LNX.2.00.1108100951590.24873@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011, Theodore Kilgore wrote:

> > Okay, I didn't realize that the different cameras used different webcam 
> > drivers as well as different stillcam drivers.
> 
> Oh, yes. They are Proprietary devices. And that means what it says. :-)
> And all different from each other, too.
>  
> > As far as I can see, there's nothing to stop anybody from adding the 
> > stillcam functionality into the webcam drivers right now.  If some 
> > common code can be abstracted out into a shared source file, so much 
> > the better.
> > 
> > That would solve the problem, right?
> 
> I think everyone involved believes that it would solve the problem. 
> 
> The question has been all along whether or not there is any other way 
> which would work. Also the question of what, exactly, "belongs" in the 
> kernel and what does not. For, if something has been historically 
> supported in userspace (stillcam support, in this case) and has worked 
> well there, I would think it is kind of too bad to have to move said 
> support into the kernel just because the same hardware requires kernel 
> support for another functionality and the two sides clash. I mean, the 
> kernel is already big enough, no? But the logic that Hans has set forth 
> seems rather compelling. 

The alternative seems to be to define a device-sharing protocol for USB
drivers.  Kernel drivers would implement a new callback (asking them to
give up control of the device), and usbfs would implement new ioctls by
which a program could ask for and relinquish control of a device.  The
amount of rewriting needed would be relatively small.

A few loose ends would remain, such as how to handle suspends, resumes,
resets, and disconnects.  Assuming usbfs is the only driver that will
want to share a device in this way, we could handle them.

Hans, what do you think?

Alan Stern

