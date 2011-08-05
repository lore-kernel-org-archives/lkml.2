Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1HERep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:34:45 -0400
Received: from banach.math.auburn.edu ([131.204.45.3]:35259 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1HERem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:34:42 -0400
Date: Fri, 5 Aug 2011 12:38:30 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <201108050857.52204.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.1108051215370.18884@banach.math.auburn.edu>
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com> <201108050857.52204.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Aug 2011, Oliver Neukum wrote:

> Am Freitag, 5. August 2011, 00:56:03 schrieb Greg KH:
> > On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
> > > I know that this problem were somewhat solved for 3G modems, with the usage
> > > of the userspace problem usb_modeswitch, and with some quirks for the USB
> > > storage driver, but I'm not sure if such tricks will scale forever, as more
> > > functions are seen on some USB devices.
> > 
> > Well, no matter how it "scales" it needs to be done in userspace, like
> > usb_modeswitch does.  We made that decision a while ago, and it is
> > working out very well.  I see no reason why you can't do it in userspace
> > as well as that is the easiest place to control this type of thing.
> > 
> > I thought we had a long discussion about this topic a while ago and came
> > to this very conclusion.  Or am I mistaken?
> 
> Circumstances change. We want to keep the stuff in user space as much and
> as long as we can. However user space has limitations:
> 
> - it has by necessity a race between resumption and access by others
> - it cannot resume anything we run a (rw) filesystem over.
> 
> Furthermore, today PM actions that lead to a loss of mode are initiated
> by user space. If we ever want to oportunistically suspend a system
> we also need to restore mode from inside the kernel.
> 
> We could avoid all that trouble, if we persuaded vendors to use plain
> USB configurations for those purposes.

But that would happen, I suspect, in an alternate universe. Better to 
anticipate the trouble, I suspect. :-{

Moreover, the spark for the current discussion was the problem of 
dual-mode cameras, which can work both as webcams and stillcams, not the 
3G modems that you mention. The problems are analogous but not identical. 

	-- dual-mode cameras are, typically, Class Proprietary devices in 
all of their functions. None of them that I know of are Mass Storage 
devices. Therefore, usb_modeswitch would have to be rewritten completely 
in order to be used for such hardware. As things stand right now, it has 
nothing at all to do with the problem. Not to say, of course, that the 
experience gained with usb_modeswitch is totally irrelevant.

	-- I don't have one of those modems, but I have the impression 
that the need to access the "disk" partition on one of them is basically a 
one-shot deal. Namely, one needs to load some firmware or so on the "disk" 
before the gadget can be used. The problem with a dual-mode camera is that 
the user ought to be able to switch at will between a 
download-the-pictures stillcam application and a stream application. 
While, of course, not being able to start one of these activities while 
the other is going on, because that would cause obvious trouble. 

The similarity of the modem-and-mass-storage device and the web-and-still 
camera is, of course, that both partake of being devices that will do more 
than one kind of thing and they need to be supported in that respect. 
Other hardware exists with similar characteristics, but sometimes the 
functionaliy is not dual but even triple, and one can reasonably suspect 
that more of this kind of thing is going to come at us in the future. I 
think it is a good occasion to sit back and think things over a bit.

Theodore Kilgore
