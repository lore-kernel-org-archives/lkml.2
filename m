Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1HJO7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:59:16 -0400
Received: from banach.math.auburn.edu ([131.204.45.3]:42227 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1HJO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:59:13 -0400
Date: Wed, 10 Aug 2011 10:03:20 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
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
In-Reply-To: <Pine.LNX.4.44L0.1108101016200.1917-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1108100951590.24873@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108101016200.1917-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Aug 2011, Alan Stern wrote:

> On Tue, 9 Aug 2011, Hans de Goede wrote:
> 
> > Hi,
> > 
> > On 08/09/2011 04:19 PM, Alan Stern wrote:
> > > On Tue, 9 Aug 2011, Hans de Goede wrote:
> > > According to Theodore, we have developed 5 drivers for them because the
> > > stillcam modes in different devices use four different vendor-specific
> > > drivers.
> > 
> > Yes, but so the the webcam modes of the different devices, so for
> > the 5 (not sure if that is the right number) dual-cam mode chipsets
> > we support there will be 5 drivers, each supporting both the
> > webcam and the access to pictures stored in memory of the chipset
> > they support. So 5 chipsets -> 5 drivers each supporting 1 chipset,
> > and both functions of the single logical device that chipset
> > represents.
> > 
> > >  Does it really make sense to combine 5 drivers into one?
> > 
> > Right, that is not the plan. The plan is to simply stop having 2 drivers
> > for 1 logical (and physical) block. So we go from 10 drivers, 5 stillcam
> > + 5 webcam, to just 5 drivers. We will also likely be able to share
> > code between the code for the 2 functionalities for things like generic
> > set / get register functions, initialization, etc.
> 
> Okay, I didn't realize that the different cameras used different webcam 
> drivers as well as different stillcam drivers.

Oh, yes. They are Proprietary devices. And that means what it says. :-)
And all different from each other, too.
 
> As far as I can see, there's nothing to stop anybody from adding the 
> stillcam functionality into the webcam drivers right now.  If some 
> common code can be abstracted out into a shared source file, so much 
> the better.
> 
> That would solve the problem, right?

I think everyone involved believes that it would solve the problem. 

The question has been all along whether or not there is any other way 
which would work. Also the question of what, exactly, "belongs" in the 
kernel and what does not. For, if something has been historically 
supported in userspace (stillcam support, in this case) and has worked 
well there, I would think it is kind of too bad to have to move said 
support into the kernel just because the same hardware requires kernel 
support for another functionality and the two sides clash. I mean, the 
kernel is already big enough, no? But the logic that Hans has set forth 
seems rather compelling. 

Theodore Kilgore
