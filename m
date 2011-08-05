Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1HEGzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 02:55:05 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40758 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1HEGzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 02:55:02 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Date: Fri, 5 Aug 2011 08:57:52 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
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
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com>
In-Reply-To: <20110804225603.GA2557@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108050857.52204.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. August 2011, 00:56:03 schrieb Greg KH:
> On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
> > I know that this problem were somewhat solved for 3G modems, with the usage
> > of the userspace problem usb_modeswitch, and with some quirks for the USB
> > storage driver, but I'm not sure if such tricks will scale forever, as more
> > functions are seen on some USB devices.
> 
> Well, no matter how it "scales" it needs to be done in userspace, like
> usb_modeswitch does.  We made that decision a while ago, and it is
> working out very well.  I see no reason why you can't do it in userspace
> as well as that is the easiest place to control this type of thing.
> 
> I thought we had a long discussion about this topic a while ago and came
> to this very conclusion.  Or am I mistaken?

Circumstances change. We want to keep the stuff in user space as much and
as long as we can. However user space has limitations:

- it has by necessity a race between resumption and access by others
- it cannot resume anything we run a (rw) filesystem over.

Furthermore, today PM actions that lead to a loss of mode are initiated
by user space. If we ever want to oportunistically suspend a system
we also need to restore mode from inside the kernel.

We could avoid all that trouble, if we persuaded vendors to use plain
USB configurations for those purposes.

	Regards
		Oliver
