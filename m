Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0GMTKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:10:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58846 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0GMTKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AIGsvro2uC81/Xn8ljHKCek6lXZRTsnnvl3qrscWOIPupk3mcnQjtBttH5dGkmf9Gy
         NOBgMPFkLf3uoY9qYVaDYXPMjTT7uSkz9oXPgL9qWmO6HqE+YLvMr5srcmEpz64hiyuk
         o43fwFmUpp+d+wwTUe43sXhTnh6Jq9su7yKBE=
MIME-Version: 1.0
In-Reply-To: <AANLkTim-yNCtMnxzzA8yJnD6CLkF2Mz-aA4E5qbYMBlz@mail.gmail.com>
References: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
	<AANLkTilvbOb0n9l6F3EHwQg3VfNNmYB1BdFbzL2Cwg_P@mail.gmail.com>
	<AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
	<AANLkTil58zbo28QL2ncTAXx9iHeQS20W8u0MuDgLaojj@mail.gmail.com>
	<AANLkTim-yNCtMnxzzA8yJnD6CLkF2Mz-aA4E5qbYMBlz@mail.gmail.com>
Date: Tue, 13 Jul 2010 15:10:15 -0400
Message-ID: <AANLkTim9EQ9nPISuH5wNsrAd8bHM-xBnpgqAi-W_ZCTi@mail.gmail.com>
Subject: Re: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
From: Alex Deucher <alexdeucher@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 2:29 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Mon, Jul 12, 2010 at 11:38 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Mon, Jul 12, 2010 at 3:54 PM, Torsten Kaiser
>> <just.for.lkml@googlemail.com> wrote:
>>> 0888e883ea5ff8fac27e813256d6c1eaede5a234 is the first bad commit
>>> commit 0888e883ea5ff8fac27e813256d6c1eaede5a234
>>> Author: Alex Deucher <alexdeucher@gmail.com>
>>> Date:   Sat Jun 12 11:50:13 2010 -0400
>>>
>>>    drm/radeon/kms: fix bandwidth calculation when sideport is present
>>>
>>>    Fixes fdo bug 27529:
>>>    https://bugs.freedesktop.org/show_bug.cgi?id=27529
>>>
>>>    Reported-by: steckdenis@yahoo.fr
>>>    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>>>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>>>
>>> :040000 040000 2ff9114469e4569e1bebd659c9632c5b59bfc238
>>> b0eb9a29c698da1eeb8289ba1180b8135a94ecd7 M     drivers
>>>
>>> My system does not have any sideport memory.
>>> The other revisions before this did boot into the correct KMS mode,
>>> but I did not test X, because I'm using that system as a remote
>>> desktop server and only sometimes the fb text console to debug
>>> something that went wrong.
>
> From the other mail:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f892034a8ce80ed7098f667aae2eb6300e570603
> is part of vanilla 2.6.35-rc4 and -rc5, but neither kernel works for
> me.
>
>> Does this patch help?
> (0001-drm-radeon-kms-fix-possible-mis-detection-of-sidepor.patch)
>
> After adding this to 2.6.35-rc5 the system boots and works so far.

I've sent the patch to Dave.

>
> But the CP is still broken:

Is this a regression?  If so, can you bisect it?

Alex

> [    0.426931] Linux agpgart interface v0.103
> [    0.427092] [drm] Initialized drm 1.1.0 20060810
> [    0.427196] [drm] radeon defaulting to kernel modesetting.
> [    0.427255] [drm] radeon kernel modesetting enabled.
> [    0.427372] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    0.429659] [drm] initializing kernel modesetting (RS690 0x1002:0x791E).
> [    0.429817] [drm] register mmio base: 0xFE9F0000
> [    0.429876] [drm] register mmio size: 65536
> [    0.430457] ATOM BIOS: ATI
> [    0.430532] radeon 0000:01:05.0: VRAM: 32M 0xDE000000 - 0xDFFFFFFF (32M used)
> [    0.430592] radeon 0000:01:05.0: GTT: 512M 0xBE000000 - 0xDDFFFFFF
> [    0.430675] [drm] radeon: irq initialized.
> [    0.430737] mtrr: type mismatch for fc000000,2000000 old:
> write-back new: write-comb
> ining
> [    0.430811] [drm] Detected VRAM RAM=32M, BAR=32M
> [    0.430868] [drm] RAM width 128bits DDR
> [    0.431011] [TTM] Zone  kernel: Available graphics memory: 2010234 kiB.
> [    0.431070] [TTM] Initializing pool allocator.
> [    0.431147] [drm] radeon: 32M of VRAM memory ready
> [    0.431205] [drm] radeon: 512M of GTT memory ready.
> [    0.431266] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    0.434654] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [    0.441719] [drm] Loading RS690/RS740 Microcode
> [    0.441926] [drm] radeon: ring at 0x00000000BE000000
> [    0.577118] [drm:r100_ring_test] *ERROR* radeon: ring test failed
> (sracth(0x15E4)=0x
> CAFEDEAD)
> [    0.577192] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
> [    0.577252] radeon 0000:01:05.0: failled initializing CP (-22).
> [    0.577310] radeon 0000:01:05.0: Disabling GPU acceleration
> [    0.577440] [drm] radeon: cp finalized
> [    0.578078] [drm] Default TV standard: NTSC
> [    0.578314] [drm] Default TV standard: NTSC
> [    0.578590] [drm] Radeon Display Connectors
> [    0.578648] [drm] Connector 0:
> [    0.578706] [drm]   VGA
> [    0.578764] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
> 0x7e5c 0x7e4c
> [    0.578837] [drm]   Encoders:
> [    0.578894] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [    0.578952] [drm] Connector 1:
> [    0.579010] [drm]   S-video
> [    0.579067] [drm]   Encoders:
> [    0.579124] [drm]     TV1: INTERNAL_KLDSCP_DAC1
> [    0.579182] [drm] Connector 2:
> [    0.579239] [drm]   HDMI-A
> [    0.579297] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
> 0x7e4c 0x7e5c
> [    0.579369] [drm]   Encoders:
> [    0.579427] [drm]     DFP3: INTERNAL_LVTM1
> [    0.773375] [drm] fb mappable at 0xFC040000
> [    0.773434] [drm] vram apper at 0xFC000000
> [    0.773491] [drm] size 786432
> [    0.773549] [drm] fb depth is 8
> [    0.773606] [drm]    pitch is 1024
> [    0.773737] fbcon: radeondrmfb (fb0) is primary device
> [    0.793240] Console: switching to colour frame buffer device 128x48
> [    0.794833] fb0: radeondrmfb frame buffer device
> [    0.794852] drm: registered panic notifier
> [    0.794871] Slow work thread pool: Starting up
> [    0.794932] Slow work thread pool: Ready
> [    0.794953] [drm] Initialized radeon 2.5.0 20080528 for
> 0000:01:05.0 on minor 0
>
>
> Torsten
>
