Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1HZTFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:05:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59144 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1HZTFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:05:51 -0400
From: "Maupin, Chase" <chase.maupin@ti.com>
To: Govindraj <govindraj.ti@gmail.com>, "Coelho, Luciano" <coelho@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: RE: 3.1-rc3 fails to boot on my pandaboard
Thread-Topic: 3.1-rc3 fails to boot on my pandaboard
Thread-Index: AQHMYxyWTpqunbR+M0aWSiJqcfnjIpUvf8Ew
Date: Fri, 26 Aug 2011 19:05:39 +0000
Message-ID: <7D46E86EC0A8354091174257B2FED1010346F40B@DLEE12.ent.ti.com>
References: <1314268769.2296.283.camel@cumari>
 <CAAL8m4whQJSXQw+E52qF2vLSBrt=RsA-r-B2q2gaW3XGiR4tYg@mail.gmail.com>
 <1314272358.2296.296.camel@cumari>
 <CAAL8m4x18v+QWFHsxhYDGRq3WmzmA+Ur7JGRrTabHrKDuvAjvw@mail.gmail.com>
In-Reply-To: <CAAL8m4x18v+QWFHsxhYDGRq3WmzmA+Ur7JGRrTabHrKDuvAjvw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Govindraj
> Sent: Thursday, August 25, 2011 6:46 AM
> To: Coelho, Luciano
> Cc: linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org; Thomas
> Gleixner; Sebastian Andrzej Siewior
> Subject: Re: 3.1-rc3 fails to boot on my pandaboard
> 
> On Thu, Aug 25, 2011 at 5:09 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Thu, 2011-08-25 at 17:05 +0530, Govindraj wrote:
> >> On Thu, Aug 25, 2011 at 4:09 PM, Luciano Coelho <coelho@ti.com>
> wrote:
> >> > Hi,
> >> >
> >> > There seems to be a problem with 3.1-rc3, which prevents it from
> booting
> >> > on my PandaBoard (ARM OMAP4).
> >> >
> >> > 3.1-rc2 works fine, so I have bisected the problem and it turns
> out to
> >> > be caused by this:
> >> >
> >> > commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464
> >> > Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >> > Date:   Thu Jul 7 22:32:17 2011 +0200
> >> >
> >> >    irq: Always set IRQF_ONESHOT if no primary handler is specified
> >> >
> >> > After reverting this commit, -rc3 boots fine.  I'm not sure where
> >> > exactly the problem is.  Maybe it's something in the omap code
> which is
> >> > broken and this patch causes the bug to show up?
> >> >
> >> > What happens is that the booting process hangs after printing out
> this:
> >> >
> >>
> >> fyi,
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-
> 2.6.git;a=commitdiff;h=69dd3d8e29e294caaf63eb5e8a72d250279f9e5f;hp=fcb8
> ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c
> >
> > Ah, thanks.  Now I see where the irq == 74 comes from. :) Still, I
> don't
> > see that on my system.
> >

FYI, I also saw this same issue on an AM37x-evm and beagleboard.  Reverting the above commit works for me to be able to see the boot messages from the file system after the kernel boots.

> 
> 69dd3d8 Revert "irq: Always set IRQF_ONESHOT if no primary handler is
> specified"
> f2b6071 drm/radeon: Extended DDC Probing for Toshiba L300D Radeon
> Mobility X1100 HDMI-A Connector
> c87019e HID: wiimote: Add status and return request handlers
> 2cb5e4b HID: wiimote: Add drm request
> 23a5a4a HID: wiimote: Register led class devices
> 26af174 HID: wiimote: Correctly call HID open/close callbacks
> 3989ef6 HID: wiimote: Simplify synchronization
> 8d3bb23 drm/ttm: ensure ttm for new node is bound before calling
> move_notify()
> eac2095 drm/ttm: unbind ttm before destroying node in accel move
> cleanup
> 7c4c396 drm/ttm: fix ttm_bo_add_ttm(user) failure path
> f5e4282 HID: usbhid: Add support for SiGma Micro chip
> 11f3a6b bridge: fix a possible net_device leak
> b6bede3 xfs: fix tracing builds inside the source tree
> 832d80a Merge branch 'for-davem' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
> fcb8ce5 Linux 3.1-rc3
> 
> 
> --
> Thanks,
> Govindraj.R
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
