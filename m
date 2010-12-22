Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0LVLcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:32:25 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50240 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0LVLcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:32:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=FEaXCZtuxZ6StuJ/8K1A+EgobBZWBqCCT84EwOBsH9+kqom51gcg/QG1TOvqhny8Vl
         4rKO4mcAqGpLNzyfhkBKvK/dy+Yj3oQAgk4xwn/QA4tvx0mMcOZUVpj7crFWOPvgQAiD
         cpADe2Dr1UVPlGr64SGToNFbW6b3tI3Ke9ixc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1293004539.19556.70.camel@thor.local>
References: <AANLkTik7SQ76zcAMk5=mgKRF7MWghVHhLtY1CtK-WPKy@mail.gmail.com>
	<1293004539.19556.70.camel@thor.local>
Date: Wed, 22 Dec 2010 12:32:21 +0100
Message-ID: <AANLkTinmzPLGkwyV-yjc0s=67hYkR+VehQd3sA9tWrah@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Remove DRIVER_DATE for UMS and KMS
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Dave Airlie <airlied@gmail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/22 Michel Dänzer <michel@daenzer.net>:
> On Mit, 2010-12-22 at 08:38 +0100, Sedat Dilek wrote:
>>
>> sorry, I still haven't setup a git-send-mail, thus sending the
>> old-fashioned way as attached patch.
>
> Your mailer might allow integrating the output of git format-patch into
> the mail body directly instead.
>
>> This patch (against linux-next) is overdue.
>>
>> "DRIVER_DATE is not maintained or upgraded on changes.
>>
>> Furthermore, one DRIVER_DATE for UMS and KMS makes no sense.
>> It is enough to bump {KMS_}DRIVER_MAJOR, {KMS_}DRIVER_MINOR and
>> {KMS_}DRIVER_PATCHLEVEL defines."
>
> What ends up being printed as the date in dmesg?
>

This patch was not complete.
I could start with KMS-enabled into runlevel-3 (IIRC version of radeon
with (null) in brackets), when wanting to startx, machine died with a
error-message.

I have sent a new patch "[PATCH] drm: Remove DRIVER_DATE and
CORE_DATE" (see [1]), which works as expected.

- Sedat -

[1] http://lists.freedesktop.org/archives/dri-devel/2010-December/006586.html

P.S.:

$ dmesg | egrep -i 'drm|radeon|kms|modeset|frame buffer'
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.37-rc6-686
root=UUID=1ceb69a7-ecf4-47e9-a231-b74e0f0a9b62 ro init=/bin/systemd
radeon.modeset=1 lapic 3
[   12.328937] [drm] Initialized drm 1.1.0
[   12.818330] [drm] radeon kernel modesetting enabled.
[   12.818500] radeon 0000:01:00.0: power state changed by ACPI to D0
[   12.818540] radeon 0000:01:00.0: power state changed by ACPI to D0
[   12.818587] radeon 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11
(level, low) -> IRQ 11
[   12.826296] [drm] initializing kernel modesetting (RV250
0x1002:0x4C66).
[   12.841960] [drm] register mmio base: 0xC0100000
[   12.842001] [drm] register mmio size: 65536
[   12.842524] radeon 0000:01:00.0: putting AGP V2 device into 4x mode
[   12.842587] radeon 0000:01:00.0: GTT: 256M 0xD0000000 - 0xDFFFFFFF
[   12.842630] radeon 0000:01:00.0: VRAM: 128M 0x00000000E0000000 -
0x00000000E7FFFFFF (64M used)
[   12.842694] [drm] Supports vblank timestamp caching Rev 1
(10.10.2010).
[   12.842731] [drm] Driver supports precise vblank timestamp query.
[   12.842785] [drm] radeon: irq initialized.
[   12.845300] [drm] Detected VRAM RAM=128M, BAR=128M
[   12.845342] [drm] RAM width 128bits DDR
[   12.848233] [drm] radeon: 64M of VRAM memory ready
[   12.848273] [drm] radeon: 256M of GTT memory ready.
[   12.850055] radeon 0000:01:00.0: WB enabled
[   12.850766] [drm] Loading R200 Microcode
[   12.969090] [drm] radeon: ring at 0x00000000D0001000
[   12.969152] [drm] ring test succeeded in 1 usecs
[   12.969481] [drm] radeon: ib pool ready.
[   12.970156] [drm] ib test succeeded in 0 usecs
[   12.971841] [drm] Panel ID String: SXGA+ Single (85MHz)
[   12.971878] [drm] Panel Size 1400x1050
[   12.983044] [drm] radeon legacy LVDS backlight initialized
[   12.983737] [drm] No TV DAC info found in BIOS
[   12.983862] [drm] Radeon Display Connectors
[   12.983897] [drm] Connector 0:
[   12.983929] [drm]   VGA
[   12.983963] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   12.984013] [drm]   Encoders:
[   12.984046] [drm]     CRT1: INTERNAL_DAC1
[   12.984080] [drm] Connector 1:
[   12.984112] [drm]   DVI-D
[   12.984144] [drm]   HPD1
[   12.984177] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[   12.984212] [drm]   Encoders:
[   12.984245] [drm]     DFP1: INTERNAL_TMDS1
[   12.984278] [drm] Connector 2:
[   12.984310] [drm]   LVDS
[   12.984342] [drm]   Encoders:
[   12.984374] [drm]     LCD1: INTERNAL_LVDS
[   12.984407] [drm] Connector 3:
[   12.984439] [drm]   S-video
[   12.984471] [drm]   Encoders:
[   12.984503] [drm]     TV1: INTERNAL_DAC2
[   12.992152] [drm] radeon: power management initialized
[   13.038149] [drm] fb mappable at 0xE0040000
[   13.038188] [drm] vram apper at 0xE0000000
[   13.038221] [drm] size 5914624
[   13.038254] [drm] fb depth is 24
[   13.038286] [drm]    pitch is 5632
[   13.108205] Console: switching to colour frame buffer device 175x65
[   13.143219] fb0: radeondrmfb frame buffer device
[   13.143386] drm: registered panic notifier
[   13.144019] [drm] Initialized radeon 2.8.0 for 0000:01:00.0 on minor 0

- EOT -
