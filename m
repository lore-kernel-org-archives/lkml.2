Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0HDEXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:23:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49582 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0HDEXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YCQUGErWNcQnT+XQhKDF+Hfr87efhWBsH+8nPRFKpj/Mffznw6mjW7DHnfDZbq+rew
         fVPUJayUOocszlwl0DSE7JCqdOSqyuySfGOgc9lK/hmYRZnJOn1UWAVHAPpcFE4lFxdQ
         znuIU89tzAekghnT983rLxIVY39rh3lm2y+40=
MIME-Version: 1.0
In-Reply-To: <20100804032733.GA21530@spacedout.fries.net>
References: <AANLkTim0jVRyqkwlGOcrg_XTvUQwcBYfWJX-aRzkkrLG@mail.gmail.com>
	<AANLkTimBY1ydg_PO9whlsO0LM64L7M09AtRX_f9q8dHl@mail.gmail.com>
	<20100804032733.GA21530@spacedout.fries.net>
Date: Tue, 3 Aug 2010 21:23:33 -0700
Message-ID: <AANLkTimq2RpQDi2AO=58-j5aiAfRemwmm2PG6w46K+QK@mail.gmail.com>
Subject: Re: 2.6.35-rc2-git5 -- [drm:drm_mode_getfb] *ERROR* invalid 
	framebuffer id
From: Bret Towe <magnade@gmail.com>
To: David Fries <david@fries.net>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 8:27 PM, David Fries <david@fries.net> wrote:
> Black (non-updating) radeon console with CONFIG_FB=m works with CONFIG_FB=y.
>
> On Mon, Jun 28, 2010 at 08:56:26AM -0700, Bret Towe wrote:
>> On Fri, Jun 11, 2010 at 1:31 PM, Miles Lane <miles.lane@gmail.com> wrote:
>> > # dmesg | grep -i drm
>> > How should I go about debugging this? ?I am running Ubuntu unstable,
>> > which just moved to the latest Xorg code (xserver-xorg-core
>> > 2:1.8.1.901-1ubuntu1 and ?xserver-xorg-video-intel 2:2.11.0-1ubuntu2
>> > ).
>> >
>> > [ ? ?0.971549] [drm] Initialized drm 1.1.0 20060810
>> > [ ? ?1.171050] [drm] set up 31M of stolen space
>> > [ ? ?2.075347] fb0: inteldrmfb frame buffer device
>> > [ ? ?2.075351] drm: registered panic notifier
>> > [ ? ?2.081609] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>> > [ ? 66.545581] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> > [ ? 75.336738] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> > [30843.394355] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> > [33302.610229] [drm:init_ring_common] *ERROR* render ring head not
>> > reset to zero ctl 00000000 head fffffffc tail 00000000 start 02000000
>> > [33302.610238] [drm:init_ring_common] *ERROR* render ring head forced
>> > to zero ctl 00000000 head 00000000 tail 00000000 start 02000000
>> > [33305.239941] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> > [35339.052446] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> >
>> > CONFIG_FB=y
>>
>> any luck on this? I'm seeing the same error with a radeon card
>> I'm on a 2.6.35-rc3 kernel btw
>> on ubuntu lucid
>>
>> and not sure if its related or not but my consoles are broken
>> in that i can't see them switching to them gives dmesg an error
>> like above
>> any dmesg or config output required say so I'll be able to add them tonight
>
> I'm having about the same problem as what you are describing.  The
> earlier boot uses VGA text, but as soon as it goes to what should be
> the framebuffer the screen goes black until X, which displays
> normally.  Switching to console from X results into the cursor
> vanishing, but the rest of what was on the screen in X continues to
> display at what should now be console.  The '*ERROR* invalid
> framebuffer id' is being displayed when I'm entering X not when
> leaving.
>
> Bret, try compiling the frame buffer into the kernel CONFIG_FB=y as
> the frame buffer is only broken for me when it's a module.  I see
> Miles has his compiled in, so I'm thinking it's a different bug.
>
> broken output
> [drm] Initialized drm 1.1.0 20060810
> [drm] radeon kernel modesetting enabled.
> radeon 0000:01:05.0: power state changed by ACPI to D0
> radeon 0000:01:05.0: power state changed by ACPI to D0
> radeon 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [drm] initializing kernel modesetting (RS480 0x1002:0x5975).
> [drm] register mmio base: 0xC0100000
> [drm] register mmio size: 65536
> [drm:rs400_gart_adjust_size] *ERROR* Forcing to 32M GART size (because of ASIC bug ?)
> [drm] Generation 2 PCI interface, using max accessible memory
> radeon 0000:01:05.0: VRAM: 128M 0x78000000 - 0x7FFFFFFF (128M used)
> radeon 0000:01:05.0: GTT: 32M 0x80000000 - 0x81FFFFFF
> [drm] radeon: irq initialized.
> [drm] Detected VRAM RAM=128M, BAR=128M
> [drm] RAM width 128bits DDR
> [TTM] Zone  kernel: Available graphics memory: 963794 kiB.
> [TTM] Initializing pool allocator.
> [drm] radeon: 128M of VRAM memory ready
> [drm] radeon: 32M of GTT memory ready.
> [drm] GART: num cpu pages 8192, num gpu pages 8192
> [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [drm] Loading R300 Microcode
> [drm] radeon: ring at 0x0000000080000000
> [drm] ring test succeeded in 1 usecs
> [drm] radeon: ib pool ready.
> [drm] ib test succeeded in 0 usecs
> [drm] Default TV standard: NTSC
> [drm] 14.318180000 MHz TV ref clk
> [drm] Panel ID String: AUO
> [drm] Panel Size 1280x800
> [drm] Radeon Display Connectors
> [drm] Connector 0:
> [drm]   VGA
> [drm]   DDC: 0x68 0x68 0x68 0x68 0x68 0x68 0x68 0x68
> [drm]   Encoders:
> [drm]     CRT1: INTERNAL_DAC2
> [drm] Connector 1:
> [drm]   LVDS
> [drm]   DDC: 0x198 0x198 0x19c 0x19c 0x1a0 0x1a0 0x1a4 0x1a4
> [drm]   Encoders:
> [drm]     LCD1: INTERNAL_LVDS
> [drm] radeon: power management initialized
> [drm] fb mappable at 0xC8040000
> [drm] vram apper at 0xC8000000
> [drm] size 4096000
> [drm] fb depth is 24
> [drm]    pitch is 5120
> fb0: radeondrmfb frame buffer device
> drm: registered panic notifier
> Slow work thread pool: Starting up
> Slow work thread pool: Ready
> [drm] Initialized radeon 2.5.0 20080528 for 0000:01:05.0 on minor 0
>
> The working CONFIG_FB=y version adds a Console: output message.  That
> message comes from drivers/char/vt.c bind_con_driver.  Any reason it
> would fail when the frame buffer is compiled as a module?
>  [drm] size 4096000
>  [drm] fb depth is 24
>  [drm]    pitch is 5120
> +Console: switching to colour frame buffer device 160x50
>  fb0: radeondrmfb frame buffer device
>  drm: registered panic notifier
>  Slow work thread pool: Starting up
>
> This is going from my non-working .config to my working .config.
>
> @@ -2107,13 +2107,13 @@ CONFIG_DRM_RADEON=m
>  # CONFIG_DRM_SAVAGE is not set
>  CONFIG_VGASTATE=m
>  # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> -CONFIG_FB=m
> +CONFIG_FB=y
>  CONFIG_FIRMWARE_EDID=y
>  CONFIG_FB_DDC=m
> -# CONFIG_FB_BOOT_VESA_SUPPORT is not set
> -CONFIG_FB_CFB_FILLRECT=m
> -CONFIG_FB_CFB_COPYAREA=m
> -CONFIG_FB_CFB_IMAGEBLIT=m
> +CONFIG_FB_BOOT_VESA_SUPPORT=y
> +CONFIG_FB_CFB_FILLRECT=y
> +CONFIG_FB_CFB_COPYAREA=y
> +CONFIG_FB_CFB_IMAGEBLIT=y
>  # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
>  CONFIG_FB_SYS_FILLRECT=m
>  CONFIG_FB_SYS_COPYAREA=m
> @@ -2133,8 +2133,11 @@ CONFIG_FB_TILEBLITTING=y
>  # CONFIG_FB_PM2 is not set
>  # CONFIG_FB_CYBER2000 is not set
>  # CONFIG_FB_ARC is not set
> +# CONFIG_FB_ASILIANT is not set
> +# CONFIG_FB_IMSTT is not set
>  CONFIG_FB_VGA16=m
>  # CONFIG_FB_UVESA is not set
> +CONFIG_FB_VESA=y
>  # CONFIG_FB_N411 is not set
>  # CONFIG_FB_HGA is not set
>  # CONFIG_FB_S1D13XXX is not set
> @@ -2191,7 +2194,7 @@ CONFIG_DISPLAY_SUPPORT=m
>  CONFIG_VGA_CONSOLE=y
>  # CONFIG_VGACON_SOFT_SCROLLBACK is not set
>  CONFIG_DUMMY_CONSOLE=y
> -CONFIG_FRAMEBUFFER_CONSOLE=m
> +CONFIG_FRAMEBUFFER_CONSOLE=y
>  # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set

I believe what had solved my problem was setting the above config option

>  CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
>  # CONFIG_FONTS is not set
>
> I tried 2.6.34-rc7 with CONFIG_FB=m and it also gives a non-updating
> console.
>
> --
> David Fries <david@fries.net>
> http://fries.net/~david/ (PGP encryption key available)
>
