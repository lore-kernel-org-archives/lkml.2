Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2JTVUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 17:20:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2JTVUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 17:20:49 -0400
Date: Sat, 20 Oct 2012 23:20:36 +0200
From: Heinz Diehl <htd@fritha.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Martin Peres <martin.peres@labri.fr>, Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121020212036.GA1698@fritha.org>
References: <1724445.dN2yMEzN6d@localhost>
 <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
 <20121020092647.GA3186@fancy-poultry.org>
 <50827174.7070109@labri.fr>
 <20121020104238.GA1539@fritha.org>
 <20121020202846.GA5826@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020202846.GA5826@joi.lan>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:gbjubfvoWgXH9n10G4s8U45XCVLwPdk1uVa5QLUQF7p
 8JQzdGl/X3HOf/R81s+j4Nxk39fmkyJ5C8dXKi+vaHQ3GYkpMD
 Vl79TVNVQyJhDvVmS0LwBzgI548WIUPh8GihkRa8EEYIJCtI9+
 nXNz1Xc9uRNrqkSREFVnP+0Tl+mRuO3t68hkdkf/mMI0a1orUK
 Rd+C8IgMSV7f92ZHdfC0CRcet5jGizmRNemoNn+xSymtgh26yZ
 ITcsKvviSPS/NioFUCTcgo1qdn40dQl6xWqL8HCsWfNMmO/RDK
 KdvRqW+oZjOMDrAOpPT5uhgCgSdQ82WAwPPMD6qBNm2Sq6BEXm
 0mFwUh69Zw3+8Gn/5saA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2012, Marcin Slusarz wrote: 

> Try this one.

It works, now I can boot again. However, nouveau seems to be dead now.
The dmesg output with your patch on top of 3.7-rc1 is:

[    3.685909] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.687784] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a8800b1
[    3.689960] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT218 (NVA8)
[    3.692471] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
[    3.695716] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    3.697087] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    3.698471] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    3.699838] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    3.701223] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
[    3.702684] ACPI Error: Field [ROMI] Base+Offset+Width 0+24+1 is beyond end of region [VROM] (length 24) (20120913/exfldio-210)
[    3.704139] ACPI Error: Method parse/execution failed[\_SB_.PCI0.PEG1.GFX0._ROM] (Node ffff880142e85cf8), AE_AML_REGION_LIMIT (20120913/psparse-536)
[    3.716183] failed to evaluate ROM got AE_AML_REGION_LIMIT
[    3.718776] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    3.721349] nouveau  [   VBIOS][0000:01:00.0] checking PCIROM for image...
[    3.724111] nouveau 0000:01:00.0: Invalid ROM contents
[    3.726663] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    3.729159] nouveau E[   VBIOS][0000:01:00.0] unable to locate usable image
[    3.731677] nouveau E[  DEVICE][0000:01:00.0] failed to create 0x10000001, -22
[    3.734231] nouveau E[     DRM] failed to create 0x80000080, -22
[    3.736097] nouveau: probe of 0000:01:00.0 failed with error -22
[    3.740523] dracut: Starting plymouth daemon

And here's the same output with plain vanilla 3.6.2:

[    3.588791] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a8800b1)
[    3.599783] vga_switcheroo: enabled
[    3.601303] [drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
[    3.602817] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[    3.604294] [drm] nouveau 0000:01:00.0: Checking PROM for VBIOS
[    3.605822] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[    3.607310] [drm] nouveau 0000:01:00.0: Checking ACPI for VBIOS
[    3.856854] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    3.859409] [drm] nouveau 0000:01:00.0: Using VBIOS from ACPI
[    3.861907] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    3.864369] [drm] nouveau 0000:01:00.0: Bios version 70.18.5d.00
[    3.866829] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    3.869479] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
[    3.870871] [drm] nouveau 0000:01:00.0: DCB version 4.0
[    3.872220] [drm] nouveau 0000:01:00.0: DCB outp 00: 02014300 00000000
[    3.873611] [drm] nouveau 0000:01:00.0: DCB conn 00: 00000040
[    3.874994] [drm] nouveau 0000:01:00.0: DCB conn 01: 00410146
[    3.876367] [drm] nouveau 0000:01:00.0: DCB conn 02: 00001261
[    3.877719] [drm] nouveau 0000:01:00.0: DCB conn 03: 00002330
[    3.879043] [drm] nouveau 0000:01:00.0: DCB conn 04: 00000400
[    3.880355] [drm] nouveau 0000:01:00.0: DCB conn 05: 00000560
[    3.881662] [drm] nouveau 0000:01:00.0: Adaptor not initialised, running VBIOS init tables.
[    3.882961] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDECD
[    3.936538] [drm] nouveau 0000:01:00.0: 0xDE34: i2c wr fail: -6
[    3.957932] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE378
[    3.987046] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEF4B
[    3.988396] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEF64
[    3.990741] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xF04B
[    3.992020] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xF0B0
[    4.018084] [TTM] Zone  kernel: Available graphics memory: 1917766 kiB
[    4.019438] [TTM] Initializing pool allocator
[    4.020694] [TTM] Initializing DMA pool allocator
[    4.021914] [drm] nouveau 0000:01:00.0: Detected 1024MiB VRAM (DDR3)
[    4.024515] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    4.083748] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.084909] [drm] No driver support for vblank timestamp query.
[    4.085985] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[    4.246449] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[    4.247560] [drm] nouveau 0000:01:00.0: 0: core 135MHz shader 270MHz memory 135MHz voltage 850mV
[    4.248707] [drm] nouveau 0000:01:00.0: 1: core 405MHz shader 810MHz memory 405MHz voltage 850mV
[    4.249807] [drm] nouveau 0000:01:00.0: 3: core 606MHz shader 1468MHz memory 667MHz voltage 1000mV
[    4.250946] [drm] nouveau 0000:01:00.0: c: core 405MHz shader 810MHz memory 405MHz
[    4.289382] [drm] nouveau 0000:01:00.0: MM: using COPY for buffer copies
[    4.668174] No connectors reported connected with modes
[    4.669252] [drm] Cannot find any crtc or sizes - going 1024x768
[    4.683844] [drm] nouveau 0000:01:00.0: allocated 1024x768 fb: 0x2c0000, bo ffff88013ab53400
[    4.685057] fb1: nouveaufb frame buffer device
[    4.686244] [drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 1
[    4.691233] dracut: Starting plymouth daemon
 
> Now, the question is: could 3.6 kernel get VBIOS by ACPI?
> If yes, please mount debugfs and send vbios.rom to me please.
> (cat /sys/kernel/debug/dri/0/vbios.rom > vbios.rom)

There's no such file on my machine (with mounted debugfs, of course).
 
