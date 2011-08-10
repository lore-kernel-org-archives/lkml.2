Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1HJUPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:15:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:39750 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1HJUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:15:06 -0400
Message-ID: <4E42E68D.6040501@infradead.org>
Date: Wed, 10 Aug 2011 17:14:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Alan Stern <stern@rowland.harvard.edu>,
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
References: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-08-2011 15:33, Theodore Kilgore escreveu:

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

Not looking on the amount of work to be done, I think that this would
give better results, IMO.

> -- doing some kind of patch job to make current arrangement somehow to 
> work better (this seems to be the position of Adam Baker; I do share
> the skepticism Hans has expressed about how well this could all be 
> pasted together)

Adam Baker's proposal of a locking between usbfs and the kernel driver seems
to be interesting, but, as he pointed, there are some side effects to consider,
like suspend/resume, PM, etc.

> -- doing something like the previous, but also figuring out how to bring 
> udev rules into play, which would make it all work better (just tossing 
> this one in, for laughs, but who knows someone might like it)

I don't think this is a good alternative.

> -- moving the kernel webcam drivers out of the kernel and doing with these 
> cameras _everything_ including webcam function through libusb. I myself do 
> not have the imagination to be able to figure out how this could be done 
> without a rather humongous amount of work (for example, which streaming 
> apps that are currently available would be able to live with this?) but 
> unless I misunderstand what he was saying, Greg K-H seems to think that 
> this would be the best thing to do.

I also don't think that this a good alternative. As Hans V. pointed, one of
our long term targets is to create per-sensor I2C drivers that are independent
from the bridges. Also, moving it to userspace would require lots of work
with the duplication of V4L and gspca core into userspace for the devices
that would be moved, and may have some performance impacts.

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
> LinuxCon or be involved in it.

It will be great to have you there for those discussions.

> When I leave Vancouver I will probably go 
> to Seattle and spend a couple of days with my oldest son, the musician, 
> before coming home on the next weekend.
> 
> Theodore Kilgore

