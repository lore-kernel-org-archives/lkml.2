Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1DLLaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:30:46 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:41193 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1DLLap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:30:45 -0400
Date: Tue, 12 Apr 2011 13:30:34 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110412113033.GA16649@iram.es>
References: <20110404235259.GA30132@iram.es> <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com> <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local> <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302535963.24704.268.camel@thor.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Micel,

On Mon, Apr 11, 2011 at 05:32:43PM +0200, Michel Dänzer wrote:
> [ Adding the dri-devel list ]
> 
> Have you ruled out any MSI related problems? I think the IRQ not working
> could explain the symptoms...

Booting with MSI disabled does not change anything. Actually on this
machine the Ethernet (tigon3) uses MSI and everything is fine. OTOH,
on my home PC (dual code Athlon64 4 1/2 years old), MSI has never worked.

> Make sure this line changes to 'WB disabled' with no_wb=1. There's a
> writeback endianness bug with modeset=1, see
> http://lists.freedesktop.org/archives/dri-devel/2011-April/009960.html .
> 

With no_wb=1 the driver goes a bit further but the X server ends
up in an infinite ioctl loop and the logs are: 

kernel: [drm] radeon kernel modesetting enabled.
kernel: checking generic (c0000000 140000) vs hw (c0000000 10000000)
kernel: fb: conflicting fb hw usage radeondrmfb vs OFfb vga,Displa - removing generic driver
kernel: [drm] initializing kernel modesetting (RV530 0x1002:0x71C7).
kernel: radeon 0000:f1:00.0: Using 64-bit DMA iommu bypass
kernel: [drm] register mmio base: 0xE8000000
kernel: [drm] register mmio size: 65536
kernel: radeon 0000:f1:00.0: Invalid ROM contents
kernel: ATOM BIOS: X1650PRO
kernel: [drm] Generation 2 PCI interface, using max accessible memory
kernel: radeon 0000:f1:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
kernel: radeon 0000:f1:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
kernel: [drm] Driver supports precise vblank timestamp query.
kernel: [drm] radeon: irq initialized.
kernel: [drm] Detected VRAM RAM=512M, BAR=256M
kernel: [drm] RAM width 128bits DDR
kernel: [TTM] Zone  kernel: Available graphics memory: 1003018 kiB.
kernel: [TTM] Initializing pool allocator.
kernel: [drm] radeon: 512M of VRAM memory ready
kernel: [drm] radeon: 512M of GTT memory ready.
kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
kernel: [drm] radeon: 1 quad pipes, 2 z pipes initialized.
kernel: [drm] PCIE GART of 512M enabled (table at 0x00040000).
kernel: radeon 0000:f1:00.0: WB disabled
kernel: [drm] Loading R500 Microcode
kernel: [drm] radeon: ring at 0x0000000020001000
kernel: [drm] ring test succeeded in 6 usecs
kernel: [drm] radeon: ib pool ready.
kernel: [drm] ib test succeeded in 0 usecs
kernel: [drm] Radeon Display Connectors
kernel: [drm] Connector 0:
kernel: [drm]   DVI-I
kernel: [drm]   HPD1
kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
kernel: [drm]   Encoders:
kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
kernel: [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
kernel: [drm] Connector 1:
kernel: [drm]   S-video
kernel: [drm]   Encoders:
kernel: [drm]     TV1: INTERNAL_KLDSCP_DAC2
kernel: [drm] Connector 2:
kernel: [drm]   DVI-I
kernel: [drm]   HPD2
kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
kernel: [drm]   Encoders:
kernel: [drm]     CRT2: INTERNAL_KLDSCP_DAC2
kernel: [drm]     DFP3: INTERNAL_LVTM1
kernel: [drm] Possible lm63 thermal controller at 0x4c
kernel: [drm] fb mappable at 0xC00C0000
kernel: [drm] vram apper at 0xC0000000
kernel: [drm] size 9216000
kernel: [drm] fb depth is 24
kernel: [drm]    pitch is 7680
kernel: checking generic (c0000000 140000) vs hw (c0000000 10000000)
kernel: fb: conflicting fb hw usage radeondrmfb vs OFfb vga,Displa - removing generic driver
kernel: fb1: radeondrmfb frame buffer device
kernel: drm: registered panic notifier
kernel: [drm] Initialized radeon 2.8.0 20080528 for 0000:f1:00.0 on minor 0
kernel: [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

There is only one display connected and it is to the first DVI connector, BTW.

	Regards,
	Gabriel
