Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1HJTkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:40:12 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2467 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1HJTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:40:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Date: Wed, 10 Aug 2011 21:39:50 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-tschai; KDE/4.6.2; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
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
References: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108102139.51086.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 10, 2011 20:33:25 Theodore Kilgore wrote:
> 
> On Wed, 10 Aug 2011, Alan Stern wrote:
> 
> > On Wed, 10 Aug 2011, Theodore Kilgore wrote:
> > 
> > > > Okay, I didn't realize that the different cameras used different webcam 
> > > > drivers as well as different stillcam drivers.
> > > 
> > > Oh, yes. They are Proprietary devices. And that means what it says. :-)
> > > And all different from each other, too.
> > >  
> > > > As far as I can see, there's nothing to stop anybody from adding the 
> > > > stillcam functionality into the webcam drivers right now.  If some 
> > > > common code can be abstracted out into a shared source file, so much 
> > > > the better.
> > > > 
> > > > That would solve the problem, right?
> > > 
> > > I think everyone involved believes that it would solve the problem. 
> > > 
> > > The question has been all along whether or not there is any other way 
> > > which would work. Also the question of what, exactly, "belongs" in the 
> > > kernel and what does not. For, if something has been historically 
> > > supported in userspace (stillcam support, in this case) and has worked 
> > > well there, I would think it is kind of too bad to have to move said 
> > > support into the kernel just because the same hardware requires kernel 
> > > support for another functionality and the two sides clash. I mean, the 
> > > kernel is already big enough, no? But the logic that Hans has set forth 
> > > seems rather compelling. 
> > 
> > The alternative seems to be to define a device-sharing protocol for USB
> > drivers.  Kernel drivers would implement a new callback (asking them to
> > give up control of the device), and usbfs would implement new ioctls by
> > which a program could ask for and relinquish control of a device.  The
> > amount of rewriting needed would be relatively small.
> > 
> > A few loose ends would remain, such as how to handle suspends, resumes,
> > resets, and disconnects.  Assuming usbfs is the only driver that will
> > want to share a device in this way, we could handle them.
> > 
> > Hans, what do you think?
> > 
> > Alan Stern
> 
> Alan,
> 
> Hans seems to have argued cogently for doing all of this in the kernel and 
> for abandoning the usbfs-based drivers for these particular drivers for 
> dual-mode cameras and, I would conjecture, for drivers for dual-mode 
> hardware in general. Therefore, I anticipate that he won't like that very 
> much.
> 
> My position:
> 
> I do not have preconceptions about how the problem gets handled, and at 
> this point I remain agnostic and believe that all approaches ought to be 
> carefully analysed. I can imagine, abstractly, that things like this 
> could be handled by
> 
> -- moving all basic functionality to the kernel, and fixing the 
> relevant libgphoto2 drivers to look to the kernel instead of to libusb. 
> (What Hans argues for, and I am not opposed if his arguments convince 
> other concerned parties)
> 
> -- doing some kind of patch job to make current arrangement somehow to 
> work better (this seems to be the position of Adam Baker; I do share
> the skepticism Hans has expressed about how well this could all be 
> pasted together)
> 
> -- doing something like the previous, but also figuring out how to bring 
> udev rules into play, which would make it all work better (just tossing 
> this one in, for laughs, but who knows someone might like it)
> 
> -- moving the kernel webcam drivers out of the kernel and doing with these 
> cameras _everything_ including webcam function through libusb. I myself do 
> not have the imagination to be able to figure out how this could be done 
> without a rather humongous amount of work (for example, which streaming 
> apps that are currently available would be able to live with this?) but 
> unless I misunderstand what he was saying, Greg K-H seems to think that 
> this would be the best thing to do.

Webcam drivers can rely on i2c sensor drivers to handle the sensor. These
sensor drivers can be used in other non-USB devices as well (particularly
embedded SoC devices). Moving webcam drivers out of the kernel would likely
mean that you end up with duplicate kernel and userspace sensor drivers.
Not a good idea.

In all fairness I have to say that most webcam drivers program the
sensor directly instead of relying on an i2c driver. Often because they
were reverse engineered. But I know of several that should really be split
into a webcam driver and a separate i2c sensor driver.

Video hardware tends to rely heavily on i2c devices hooked up to them. The
big advantage of keeping everything in the kernel is that that makes i2c
driver sharing between USB, PCI, SoC, etc. much easier. Video hardware
also often has to toggle between different modes or functionalities (e.g.
analog TV vs DVB, MPEG encoded video vs raw). Having all components in the
kernel makes this a much easier job.

I think the approach favored by Hans de Goede is the right one based on what
I've read.

Whatever solution is chosen, in no way should that ever force us to duplicate
i2c sensor control in userspace. This would completely defeat all our efforts
to make sensor drivers reusable between webcams and SoCs.

Regards,

	Hans

> 
> Which one of these possibile approaches gets adopted is a policy issue 
> which I would consider is ultimately way above my pay grade.
> 
> My main motivation for bringing up the issue was to get it to the front 
> burner so that _something_ gets done. It is a matter which has been left 
> alone for too long. Therefore, I am very glad that the matter is being 
> addressed.
> 
> Let me add to this that I have gotten permission for time off and for a 
> expense money which might possibly cover my air fare. I hope to arrive in 
> Vancouver by sometime on Monday and intend to attend the mini-summit. I 
> suggest that we get all intersted parties together and figure out what is 
> the best way to go.
> 
> I hope everyone who is actively concerned can meet in Vancouver, and if 
> all goes well then on Monday as well as Tuesday. I can hang around for 
> another day or two after Tuesday, but I do not expect to register for 
> LinuxCon or be involved in it. When I leave Vancouver I will probably go 
> to Seattle and spend a couple of days with my oldest son, the musician, 
> before coming home on the next weekend.
> 
> Theodore Kilgore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
