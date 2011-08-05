Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1HEAeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:34:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:56710 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1HEAeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:34:04 -0400
Message-ID: <4E3B3A4C.9010700@infradead.org>
Date: Thu, 04 Aug 2011 21:33:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
CC: Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com> <CAA6KcBBZv7bvVxvEWOYL83igpNZHyzh=bcGxh6Dr5aKsvJK5Cg@mail.gmail.com>
In-Reply-To: <CAA6KcBBZv7bvVxvEWOYL83igpNZHyzh=bcGxh6Dr5aKsvJK5Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-08-2011 20:22, Matthew Dharm escreveu:
> On Thu, Aug 4, 2011 at 3:56 PM, Greg KH <greg@kroah.com <mailto:greg@kroah.com>> wrote:
> 
>     On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
>     > I know that this problem were somewhat solved for 3G modems, with the usage
>     > of the userspace problem usb_modeswitch, and with some quirks for the USB
>     > storage driver, but I'm not sure if such tricks will scale forever, as more
>     > functions are seen on some USB devices.
> 
>     Well, no matter how it "scales" it needs to be done in userspace, like
>     usb_modeswitch does.  We made that decision a while ago, and it is
>     working out very well.  I see no reason why you can't do it in userspace
>     as well as that is the easiest place to control this type of thing.
> 
>     I thought we had a long discussion about this topic a while ago and came
>     to this very conclusion.  Or am I mistaken?
> 
>  
> We keep having the discussion over and over again.  But, you are correct: the conclusion was that this all needs to live in userspace.

In the case of 3G modem x USB storage only, it is possible to handle it on userspace.

However, when there are more functions added, an they're not (completely) mutually exclusive,
then I don't see an easy way (if is there a way) for doing it at userspace.

Several devices offer more than one function at the same time, but some
resources are mutually exclusive. A TV stick with just one tuner, and
both analog and digital demods offer both analog and digital TV at the
same time. So, both analog and digital parts of the driver will offer
the device to userspace. However, unpredictable results will happen if
userspace tries to use both at the same time.

The Digital camera devices that offer PTP transfers and V4L support also
fall at the same type of trouble. Some of those devices just delete
all pictures from the memory, if streaming is started. So, receiving
an automatic Skype video call may delete all pictures you took.

Worse than that, currently, the PTP protocol is handled via libusb, while
streaming is done via V4L2 API.

The best technical approach, IMO, is to implement the PTP protocol in
kernelspace, and do some sort of inter-subsystem locking to prevent such
troubles.

Regards,
Mauro
