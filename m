Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1BQRFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:05:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38123 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1BQRFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:05:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dZQnqbsu/g0K7ykp6TuM3/i9geL+cNMLLYfEx/SqgQ0rFayrxr1BV9IR/nlHGUmnex
         7Vioa/o/49F1541akg80vDeQmNqZx9YvKdssrlNtz2zaaKdZJJpLxnNcL9IIGNyuLqZX
         pTDmFEohsjlabHjhoy+lbLN0zFjFT7ISSAdAc=
MIME-Version: 1.0
In-Reply-To: <20110217141858.GA4746@swordfish.minsk.epam.com>
References: <20110217141858.GA4746@swordfish.minsk.epam.com>
Date: Thu, 17 Feb 2011 12:04:43 -0500
Message-ID: <AANLkTimLEUxpya8yku4Re=MQZrGVH9bTWubj3+fbw1Dc@mail.gmail.com>
Subject: Re: bisected: 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff is the first
 bad commit
From: Alex Deucher <alexdeucher@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Jerome Glisse <jglisse@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 9:18 AM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> Hello,
>
> Commit 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff has broken video output on my Radeon HD 5470 --
> see screenshot attached.

Should be fixed in this commit:
http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=9f4283f49f0a96a64c5a45fe56f0f8c942885eef

Alex


>
> bisect log:
> git bisect start '--' 'drivers/gpu/drm/radeon/'
> # bad: [e53b2057d8fccc3394cc38463171df948ce43aaa] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> git bisect bad e53b2057d8fccc3394cc38463171df948ce43aaa
> # good: [87364760de5d631390c478fcbac8db1b926e0adf] drm/radeon/kms: fix s/r issues with bios scratch regs
> git bisect good 87364760de5d631390c478fcbac8db1b926e0adf
> # good: [4eace7fdfa1f8ac2f0a833e12bd07eeb453ec9ef] drm/radeon/kms: 6xx/7xx big endian fixes
> git bisect good 4eace7fdfa1f8ac2f0a833e12bd07eeb453ec9ef
> # good: [501834349e872ed4115eea3beef65ca9eeb5528e] drm/radeon/kms: fix tracking of BLENDCNTL, COLOR_CHANNEL_MASK, and GB_Z on r300
> git bisect good 501834349e872ed4115eea3beef65ca9eeb5528e
> # good: [c2049b3d29f47ed3750226dc51251a3404c85876] drm/radeon/kms: improve 6xx/7xx CS error output
> git bisect good c2049b3d29f47ed3750226dc51251a3404c85876
> # good: [265aa6c8d8822c9074a2174e8c9f31a37fa02e50] drm/radeon/kms: fix a few more atombios endian issues
> git bisect good 265aa6c8d8822c9074a2174e8c9f31a37fa02e50
> # good: [a4b40d5d97f5c9ad0b7f4bf2818291ca184bb433] drm/radeon/kms: add bounds checking to avivo pll algo
> git bisect good a4b40d5d97f5c9ad0b7f4bf2818291ca184bb433
> # bad: [5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff] drm/radeon/kms: hopefully fix pll issues for real (v3)
> git bisect bad 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff
>
>
> 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff is the first bad commit
> commit 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Mon Feb 14 11:43:11 2011 -0500
>
>    drm/radeon/kms: hopefully fix pll issues for real (v3)
>
>    The problematic boards have a recommended reference divider
>    to be used when spread spectrum is enabled on the laptop panel.
>    Enable the use of the recommended reference divider along with
>    the new pll algo.
>
>    v2: testing options
>
>    v3: When using the fixed reference divider with LVDS, prefer
>    min m to max p and use fractional feedback dividers.
>
>    Fixes:
>    https://bugzilla.kernel.org/show_bug.cgi?id=28852
>    https://bugzilla.kernel.org/show_bug.cgi?id=24462
>    https://bugzilla.kernel.org/show_bug.cgi?id=26552
>    MacbookPro issues reported by Justin Mattock <justinmattock@gmail.com>
>
>    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>    Cc: stable@kernel.org
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> :040000 040000 8736f993b97cc8370fd29048761a1e0da4969306 657bdb221e3f4da6efdfec02f8f348db5a537b29 M      drivers
>
>
>  kernel: [    2.292708] [drm] Initialized drm 1.1.0 20060810
>  kernel: [    2.292954] [drm] radeon defaulting to kernel modesetting.
>  kernel: [    2.293028] [drm] radeon kernel modesetting enabled.
>  kernel: [    2.293156] radeon 0000:01:00.0: power state changed by ACPI to D0
>  kernel: [    2.293238] radeon 0000:01:00.0: power state changed by ACPI to D0
>  kernel: [    2.293322] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>  kernel: [    2.293404] radeon 0000:01:00.0: setting latency timer to 64
>  kernel: [    2.296184] [drm] initializing kernel modesetting (CEDAR 0x1002:0x68E0).
>  kernel: [    2.296406] [drm] register mmio base: 0xB4000000
>  kernel: [    2.296477] [drm] register mmio size: 131072
>  kernel: [    2.296835] ATOM BIOS: Acer
>  kernel: [    2.297009] radeon 0000:01:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
>  kernel: [    2.297103] radeon 0000:01:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
>  kernel: [    2.298370] [drm] Detected VRAM RAM=512M, BAR=256M
>  kernel: [    2.298450] [drm] RAM width 64bits DDR
>  kernel: [    2.298800] [TTM] Zone  kernel: Available graphics memory: 1946448 kiB.
>  kernel: [    2.298876] [TTM] Initializing pool allocator.
>  kernel: [    2.299366] [drm] radeon: 512M of VRAM memory ready
>  kernel: [    2.299440] [drm] radeon: 512M of GTT memory ready.
>  kernel: [    2.299581] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>  kernel: [    2.299659] [drm] Driver supports precise vblank timestamp query.
>  kernel: [    2.299831] radeon 0000:01:00.0: irq 41 for MSI/MSI-X
>  kernel: [    2.299840] radeon 0000:01:00.0: radeon: using MSI.
>  kernel: [    2.299995] [drm] radeon: irq initialized.
>  kernel: [    2.300066] [drm] GART: num cpu pages 131072, num gpu pages 131072
>  kernel: [    2.300953] [drm] Loading CEDAR Microcode
>  kernel: [    2.303973] radeon 0000:01:00.0: WB enabled
>  kernel: [    2.320988] [drm] ring test succeeded in 0 usecs
>  kernel: [    2.321411] [drm] radeon: ib pool ready.
>  kernel: [    2.324453] [drm] ib test succeeded in 0 usecs
>  kernel: [    2.327055] [drm] Radeon Display Connectors
>  kernel: [    2.327126] [drm] Connector 0:
>  kernel: [    2.327193] [drm]   LVDS
>  kernel: [    2.327259] [drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
>  kernel: [    2.327348] [drm]   Encoders:
>  kernel: [    2.327414] [drm]     LCD1: INTERNAL_UNIPHY
>  kernel: [    2.327483] [drm] Connector 1:
>  kernel: [    2.327551] [drm]   HDMI-A
>  kernel: [    2.327617] [drm]   HPD1
>  kernel: [    2.327683] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
>  kernel: [    2.327772] [drm]   Encoders:
>  kernel: [    2.327839] [drm]     DFP1: INTERNAL_UNIPHY1
>  kernel: [    2.327909] [drm] Connector 2:
>  kernel: [    2.328004] [drm]   VGA
>  kernel: [    2.328071] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
>  kernel: [    2.328159] [drm]   Encoders:
>  kernel: [    2.328226] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
>  kernel: [    2.334272] [drm] Internal thermal controller with fan control
>  kernel: [    2.334709] [drm] radeon: power management initialized
>  kernel: [    2.734897] [drm] fb mappable at 0xA0141000
>  kernel: [    2.734968] [drm] vram apper at 0xA0000000
>  kernel: [    2.735037] [drm] size 4325376
>  kernel: [    2.735104] [drm] fb depth is 24
>  kernel: [    2.735170] [drm]    pitch is 5632
>  kernel: [    2.820545] Refined TSC clocksource calibration: 2261.390 MHz.
>  kernel: [    2.820560] Switching to clocksource tsc
>  kernel: [    3.727928] Console: switching to colour frame buffer device 170x48
>  kernel: [    3.730609] fb0: radeondrmfb frame buffer device
>  kernel: [    3.730611] drm: registered panic notifier
>  kernel: [    3.730684] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:00.0 on minor 0
>  kernel: [    3.736754] brd: module loaded
>
>
>
>        Sergey
