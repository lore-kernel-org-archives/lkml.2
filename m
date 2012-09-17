Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2IQTaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:30:22 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:59702
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417Ab2IQTaU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:30:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI9371I542M1432Id6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAIE6C-02-EL9-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Andres Freund <andres@anarazel.de>
CC: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Topic: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Index: AQHNlMf4cJj+N2GqCk+osvT7J0ZY3JeOgYkggABg+QD//7NwcIAAhHWA//+4SPA=
Date: Mon, 17 Sep 2012 19:30:12 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02C433574@sausexdag03.amd.com>
References: <201209171329.15699.andres@anarazel.de>
 <201209171555.43008.andres@anarazel.de>
 <A3397C8B8B789E45844E7EC5DEAD89D02C4333B6@sausexdag03.amd.com>
 <201209171915.45267.andres@anarazel.de>
In-Reply-To: <201209171915.45267.andres@anarazel.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.12.207]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andres Freund [mailto:andres@anarazel.de]
> Sent: Monday, September 17, 2012 1:16 PM
> To: Deucher, Alexander
> Cc: LKML; David Airlie; dri-devel@lists.freedesktop.org
> Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
> allocate a PPLL
> 
> Hi,
> 
> On Monday, September 17, 2012 04:24:08 PM Deucher, Alexander wrote:
> > > On Monday, September 17, 2012 03:16:56 PM Deucher, Alexander wrote:
> > > > > While debugging another issue I upgraded from v3.6-rc4 to latest git
> > > > > (which exactly is v3.6-rc6). After X started up one of my three
> > > > > monitors blacked out. A look into the kernel log revealed:
> > > > > [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a PPLL
> > > >
> > > > What 3 monitors are you using (DVI, HDMI, DP, VGA)? Note that there
> are
> > > > only 2 PLLs for non-DP monitors, so if you are trying to use more than
> > > > 2 non-DP monitors, it's not supported right now and if it worked
> > > > before, it was random luck.  If you want to use 3+ monitors, only 2
> > > > can be non-DP, the rest need to be DP.  If you use a DP to DVI/HDMI
> > > > adapter, it must be active (looks like DP to the GPU), passive
> > > > adapters just pass through native DVI/HDMI.  That said, I've got a set
> > > > of patches for 3.7 to allow PLL sharing properly for non-DP displays,
> > > > but it's too invasive for -fixes.
> > >
> > > 2DVI, 1DP via an supposedly active converter. I can try a native DP
> > > cable, its just too short, so I will have to move the monitor to the
> > > ground ;)
> > >
> > > Can I check its really an active connector?
> >
> > Try the attached debugging patch.  It will tell us what PPLLs are getting
> > allocated and what type of sink we detect on the DP port (DP or non-DP)
> [    1.844382] [drm] Initialized drm 1.1.0 20060810
> [    1.867560] [drm] radeon defaulting to kernel modesetting.
> [    1.890474] [drm] radeon kernel modesetting enabled.
> [    1.913006] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA -
> removing
> generic driver
> [    1.981793] [drm] initializing kernel modesetting (BARTS 0x1002:0x6738
> 0x174B:0x174B).
> [    1.982323] [drm] register mmio base: 0xFBEC0000
> [    1.982522] [drm] register mmio size: 131072
> [    1.983880] [drm] Detected VRAM RAM=1024M, BAR=256M
> [    1.984072] [drm] RAM width 256bits DDR
> [    1.985141] [drm] radeon: 1024M of VRAM memory ready
> [    1.985345] [drm] radeon: 512M of GTT memory ready.
> [    1.985575] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    1.985779] [drm] Driver supports precise vblank timestamp query.
> [    1.986252] [drm] radeon: irq initialized.
> [    1.986454] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    1.987226] [drm] probing gen 2 caps for device 8086:340a = 2/0
> [    1.987426] [drm] enabling PCIE gen 2 link speeds, disable with
> radeon.pcie_gen2=0
> [    1.987930] [drm] Loading BARTS Microcode
> [    1.990807] [drm] PCIE GART of 512M enabled (table at
> 0x0000000000040000).
> [    2.008503] [drm] ring test on 0 succeeded in 3 usecs
> [    2.009029] [drm] ib test on ring 0 succeeded in 0 usecs
> [    2.009728] [drm] Radeon Display Connectors
> [    2.009914] [drm] Connector 0:
> [    2.010103] [drm]   DP-1
> [    2.010283] [drm]   HPD4
> [    2.010464] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c
> 0x643c
> [    2.010734] [drm]   Encoders:
> [    2.010921] [drm]     DFP1: INTERNAL_UNIPHY2
> [    2.011112] [drm] Connector 1:
> [    2.011295] [drm]   HDMI-A-1
> [    2.011478] [drm]   HPD3
> [    2.011662] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c
> 0x646c
> [    2.011932] [drm]   Encoders:
> [    2.012119] [drm]     DFP2: INTERNAL_UNIPHY2
> [    2.012324] [drm] Connector 2:
> [    2.012512] [drm]   DVI-D-1
> [    2.012695] [drm]   HPD1
> [    2.012881] [drm]   DDC: 0x6480 0x6480 0x6484 0x6484 0x6488 0x6488 0x648c
> 0x648c
> [    2.013152] [drm]   Encoders:
> [    2.013340] [drm]     DFP3: INTERNAL_UNIPHY1
> [    2.013528] [drm] Connector 3:
> [    2.013712] [drm]   DVI-I-1
> [    2.013898] [drm]   HPD6
> [    2.014082] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c
> 0x647c
> [    2.014352] [drm]   Encoders:
> [    2.014538] [drm]     DFP4: INTERNAL_UNIPHY
> [    2.014724] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [    2.015014] [drm] Internal thermal controller with fan control
> [    2.016370] [drm] radeon: power management initialized
> [    2.022137] [drm] DP sink type 0x13
> [    2.133666] [drm] fb mappable at 0xD0142000
> [    2.133793] [drm] vram apper at 0xD0000000
> [    2.133919] [drm] size 16384000
> [    2.134044] [drm] fb depth is 24
> [    2.134170] [drm]    pitch is 10240
> [    2.134358] fbcon: radeondrmfb (fb0) is primary device
> [    2.134901] [drm] crtc 0 using pll 0x2
> [    2.362257] [drm] crtc 1 using pll 0x1
> [    2.386709] [drm] crtc 2 using pll 0x0
> [    2.472275] fb0: radeondrmfb frame buffer device
> [    2.472300] drm: registered panic notifier
> [    2.472325] [drm] Initialized radeon 2.22.0 20080528 for 0000:08:00.0 on
> minor 0
> [   60.056358] [drm] DP sink type 0x13
> [   60.205905] [drm] DP sink type 0x13
> [   60.679305] [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a
> PPLL
> [   60.679310] [drm] crtc 0 using pll 0xff
> [   60.789183] [drm] crtc 1 using pll 0x2
> [   60.819594] [drm] crtc 2 using pll 0x1
> [   61.926401] [drm] DP sink type 0x13
> [   73.022055] [drm] DP sink type 0x13
> [   73.567827] [drm] DP sink type 0x13
> [ 2654.041357] [drm] crtc 0 using pll 0x2
> [ 2654.146105] [drm] crtc 1 using pll 0x0
> [ 2654.193906] [drm] crtc 2 using pll 0x1
> [ 2699.743567] [drm] DP sink type 0x13
> [ 2699.892998] [drm] DP sink type 0x13
> [ 2699.982947] [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a
> PPLL
> [ 2699.982950] [drm] crtc 0 using pll 0xff
> [ 2700.104885] [drm] crtc 1 using pll 0x2
> [ 2700.150563] [drm] crtc 2 using pll 0x1
> [ 2700.289148] [drm] DP sink type 0x13
> [ 2700.785181] [drm] DP sink type 0x13
> [ 2730.400834] [drm] crtc 0 using pll 0x2
> [ 2730.448034] [drm] crtc 1 using pll 0x0
> [ 2730.490630] [drm] crtc 2 using pll 0x1
> [ 2737.092937] [drm] DP sink type 0x13
> [ 2737.242505] [drm] DP sink type 0x13
> [ 2737.331883] [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a
> PPLL
> [ 2737.331886] [drm] crtc 0 using pll 0xff
> [ 2737.453714] [drm] crtc 1 using pll 0x2
> [ 2737.509907] [drm] crtc 2 using pll 0x1
> [ 2737.645287] [drm] DP sink type 0x13
> [ 2738.207736] [drm] DP sink type 0x13
> [ 2763.766354] [drm] DP sink type 0x13
> [ 2763.882633] [drm] DP sink type 0x13
> [ 2764.118995] [drm] crtc 0 using pll 0x2
> [ 2764.223623] [drm] crtc 1 using pll 0x0
> [ 2764.273047] [drm] crtc 2 using pll 0x1
> [ 2767.566733] [drm] DP sink type 0x13
> 

I think I see the problem.  I think it's a limitation of the current current modesetting API.  The current API sets up each display independently which doesn't work so well if there are resource restrictions.  There shouldn't be any contention on your board since you are only using 2 non-DP displays.  It looks like X is mapping different crtcs to displays than the kernel fb.  Initially the kernel set up the follow:

> [    2.134901] [drm] crtc 0 using pll 0x2
> [    2.362257] [drm] crtc 1 using pll 0x1
> [    2.386709] [drm] crtc 2 using pll 0x0

Crtc 0 -> DCPLL -> DP
Crtc 1 -> PPLL2 -> DVI
Crtc 2 -> PPLL1 -> DVI

When X loads, it tried to set a different crtc to display mapping:

> [   60.679310] [drm] crtc 0 using pll 0xff
> [   60.789183] [drm] crtc 1 using pll 0x2
> [   60.819594] [drm] crtc 2 using pll 0x1

Crtc 0 -> INVALID -> DVI 0
Crtc 1 -> DCPLL -> DP
Crtc 2 -> PPLL2 -> DVI 1

Crtc 0 should have used PPLL1 or PPLL2, but they were already in use by crtc 1 and crtc  2 from the previous modeset.  Since the modeset API is not atomic, it doesn't have the whole picture.  I'm not sure of a good solution right now prior to the new atomic modeset API that is under discussion.  I guess we can revert the patch for 3.6.  For 3.7 I guess we need to validate the actual connector to make sure we aren't trying to set a different configuration relating to the same connector without first tearing down the first one.  In the interim, you should be able to work around it by disabling the non-DP outputs and then bringing than back up.

Alex

> > > The patchset you referenced is in alexdeucher/drm-next-3.7-wip if I saw
> > > that correctly? Will test it with a passive connector I have lying
> > > arround.
> >
> > Yes.  Note that PLLs can only be shared for non-DP monitors if the clocks
> > are the same.
> That should be fine, two of the three monitors are the same.
> 
> Greetings,
> 
> Andres


