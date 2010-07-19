Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934678Ab0GSOXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:23:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37958 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab0GSOXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LcFF2rE59qiNwqE1l2cn54AXf5qy4b2doCyFzQOJoCcN2zu11NZeo8k7HVwekmGA9e
         MAOUupeatc6yDeMhCXeI9Kz9CigdlQVcfJCupAFSRGpMt+KAX3OCU4M6lQFFAteW48r2
         wGGxwoW1kyg9L7LPyTwaIDLuY8KJjBhPd487c=
MIME-Version: 1.0
In-Reply-To: <201007171856.39564.edt@aei.ca>
References: <201007171856.39564.edt@aei.ca>
Date: Mon, 19 Jul 2010 10:23:17 -0400
Message-ID: <AANLkTimLgcFQIAVqdp1qEHGH4dWf8IB-oDRsbJ1zlHNF@mail.gmail.com>
Subject: Re: Regression 2.6.34+ -> 2.6.34-rc5: radeon KMS rs780 problems
From: Alex Deucher <alexdeucher@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 6:56 PM, Ed Tomlinson <edt@aei.ca> wrote:
> Hi,
>
> My 790gx chipset supplies an rs780.  With .34+ all is ok.  With .35-rc5 basic function seems ok (kde works) but
> games like extreme tux racer have problems.  The cursor does not display when on the tux racer window and
> various objects flicker on and off as I attempt to play the game.

Did you update anything on the userspace side (ddx, mesa, xserver)?
Can you bisect what commit is causing the problems?

>
> Here is what .34+ detects (think this kernel has a drm-radeon-testing from may or early june)
>
> [    1.370735] [drm] Initialized drm 1.1.0 20060810
> [    1.376014] [drm] radeon defaulting to kernel modesetting.
> [    1.382041] [drm] radeon kernel modesetting enabled.
> [    1.387560] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    1.395205] radeon 0000:01:05.0: setting latency timer to 64
> [    1.397347] [drm] initializing kernel modesetting (RS780 0x1002:0x9614).
> [    1.404961] [drm] register mmio base: 0xFE9F0000
> [    1.410036] [drm] register mmio size: 65536
> [    1.415328] ATOM BIOS: B27722
> [    1.418612] [drm] Clocks initialized !
> [    1.422740] [drm] 3 Power State(s)
> [    1.426486] [drm] State 0 Default (default)
> [    1.431081] [drm]    1 Clock Mode(s)
> [    1.434831] [drm]            0 engine: 300000
> [    1.438773] [drm] State 1 Performance
> [    1.442897] [drm]    1 Clock Mode(s)
> [    1.446648] [drm]            0 engine: 500000
> [    1.450589] [drm] State 2 Default
> [    1.454344] [drm]    1 Clock Mode(s)
> [    1.458093] [drm]            0 engine: 500000
> [    1.462038] [drm] radeon: power management initialized
> [    1.467705] radeon 0000:01:05.0: VRAM: 256M 0xC0000000 - 0xCFFFFFFF (256M used)
> [    1.475724] radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
> [    1.485117] [drm] Detected VRAM RAM=256M, BAR=256M
> [    1.490391] [drm] RAM width 32bits DDR
> [    1.494785] [TTM] Zone  kernel: Available graphics memory: 3956838 kiB.
> [    1.502042] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
> [    1.509465] [drm] radeon: 256M of VRAM memory ready
> [    1.514825] [drm] radeon: 512M of GTT memory ready.
> [    1.520236] [drm] radeon: irq initialized.
> [    1.524739] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    1.532253] [drm] Loading RS780 Microcode
>
> with .35-rc5 it finds a different ammount of VRAM.  Hardware wise there is 128M of sideport ram.

2.6.35 added support for vram greater then the size of the PCI
framebuffer BAR (256 MB in your case).  The amount of vram accessible
to the CPU is limited by the size of the PCI framebuffer BAR, however
the GPU can access the entire amount. 2.6.35 works around this
restriction so that the CPU can access the entire amount of vram.

Alex

>
>  [    1.361622] [drm] Initialized drm 1.1.0 20060810
>  [    1.366843] [drm] radeon defaulting to kernel modesetting.
>  [    1.372863] [drm] radeon kernel modesetting enabled.
>  [    1.378371] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>  [    1.386003] radeon 0000:01:05.0: setting latency timer to 64
>  [    1.388242] [drm] initializing kernel modesetting (RS780 0x1002:0x9614).
>  [    1.395870] [drm] register mmio base: 0xFE9F0000
>  [    1.400940] [drm] register mmio size: 65536
>  [    1.406238] ATOM BIOS: B27722
>  [    1.409531] [drm] Clocks initialized !
>  [    1.413688] radeon 0000:01:05.0: VRAM: 384M 0xC0000000 - 0xD7FFFFFF (384M used)
>  [    1.421706] radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
>  [    1.429481] [drm] Detected VRAM RAM=384M, BAR=256M
>  [    1.436429] [drm] RAM width 32bits DDR
>  [    1.440829] [TTM] Zone  kernel: Available graphics memory: 3956866 kiB.
>  [    1.448096] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
>  [    1.455348] [TTM] Initializing pool allocator.
>  [    1.460471] [drm] radeon: 384M of VRAM memory ready
>  [    1.465824] [drm] radeon: 512M of GTT memory ready.
>  [    1.471255] [drm] radeon: irq initialized.
>  [    1.475760] [drm] GART: num cpu pages 131072, num gpu pages 131072
>  [    1.483280] [drm] Loading RS780 Microcode
>
> User space/firmware/bios is the same in both cases.
>
> Idea?
> Ed Tomlinson
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
