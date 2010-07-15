Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab0GOOv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:51:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61117 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382Ab0GOOv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K/RFiiqadNOx9AHx0PT1ZH1h3sKhxpgnn09MppTADH4+M2NDOSg2XDEDkBqrqomfhD
         YiNOi3MAynyxW/ezek5DYWJzX1SW77CTKkHmqw/SPkc3EVanNsjmJ9S6LGg+jwHKmDjP
         wwg1QDHZodsg3fXfkNroZhhYT3Y8ZC2oZFud4=
MIME-Version: 1.0
In-Reply-To: <AANLkTilaL1W4CBp4xPcqMyV0aeJ_w1ltgM0RimZLrcIk@mail.gmail.com>
References: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
	<AANLkTilvbOb0n9l6F3EHwQg3VfNNmYB1BdFbzL2Cwg_P@mail.gmail.com>
	<AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
	<AANLkTil58zbo28QL2ncTAXx9iHeQS20W8u0MuDgLaojj@mail.gmail.com>
	<AANLkTim-yNCtMnxzzA8yJnD6CLkF2Mz-aA4E5qbYMBlz@mail.gmail.com>
	<AANLkTim9EQ9nPISuH5wNsrAd8bHM-xBnpgqAi-W_ZCTi@mail.gmail.com>
	<AANLkTikjXiBoR3c5g6QaNfQKfX4vWUW8mt0AdomMa8at@mail.gmail.com>
	<4C3E103A.3030706@freedesktop.org>
	<AANLkTinePpZEsWShq8EB-No-CAQQsaDwLUbLVaSmrG5R@mail.gmail.com>
	<AANLkTilWzpu6Re9HG2jTqpHUU7NohULOEgHqGT4yTIaz@mail.gmail.com>
	<AANLkTilaL1W4CBp4xPcqMyV0aeJ_w1ltgM0RimZLrcIk@mail.gmail.com>
Date: Thu, 15 Jul 2010 10:51:52 -0400
Message-ID: <AANLkTinyaeN7qvSFqK1da_S7o1UT9HzisdyYGJd0vrOf@mail.gmail.com>
Subject: Re: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
From: Alex Deucher <alexdeucher@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jerome Glisse <glisse@freedesktop.org>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 1:49 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Thu, Jul 15, 2010 at 12:16 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> I discussed this with Jerome and I think we found the root cause.
>> Does this patch help?
> (patch 0001-drm-radeon-kms-fix-gtt-MC-base-alignment-on-rs4xx-rs.patch)
>
> Yes:
> [    0.426978] Linux agpgart interface v0.103
> [    0.427141] [drm] Initialized drm 1.1.0 20060810
> [    0.427242] [drm] radeon defaulting to kernel modesetting.
> [    0.427300] [drm] radeon kernel modesetting enabled.
> [    0.427417] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    0.429732] [drm] initializing kernel modesetting (RS690 0x1002:0x791E).
> [    0.429890] [drm] register mmio base: 0xFE9F0000
> [    0.429948] [drm] register mmio size: 65536
> [    0.430537] ATOM BIOS: ATI
> [    0.430612] radeon 0000:01:05.0: VRAM: 32M 0xDE000000 - 0xDFFFFFFF (32M used)
> [    0.430672] radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
> [    0.430754] [drm] radeon: irq initialized.
> [    0.430817] mtrr: type mismatch for fc000000,2000000 old:
> write-back new: write-combining
> [    0.430890] [drm] Detected VRAM RAM=32M, BAR=32M
> [    0.430947] [drm] RAM width 128bits DDR
> [    0.431090] [TTM] Zone  kernel: Available graphics memory: 2010234 kiB.
> [    0.431149] [TTM] Initializing pool allocator.
> [    0.431224] [drm] radeon: 32M of VRAM memory ready
> [    0.431283] [drm] radeon: 512M of GTT memory ready.
> [    0.431343] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    0.434732] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [    0.441796] [drm] Loading RS690/RS740 Microcode
> [    0.442006] [drm] radeon: ring at 0x00000000A0000000
> [    0.442080] [drm] ring test succeeded in 1 usecs
> [    0.442223] [drm] radeon: ib pool ready.
> [    0.442289] [drm] ib test succeeded in 0 usecs
> [    0.442370] [drm] Default TV standard: NTSC
> [    0.442587] [drm] Default TV standard: NTSC
> [    0.442866] [drm] Radeon Display Connectors
> [    0.442924] [drm] Connector 0:
> [    0.442981] [drm]   VGA
> [    0.443039] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
> 0x7e5c 0x7e4c
> [    0.443111] [drm]   Encoders:
> [    0.443169] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [    0.443227] [drm] Connector 1:
> [    0.443284] [drm]   S-video
> [    0.443340] [drm]   Encoders:
> [    0.443398] [drm]     TV1: INTERNAL_KLDSCP_DAC1
> [    0.443455] [drm] Connector 2:
> [    0.443512] [drm]   HDMI-A
> [    0.443570] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
> 0x7e4c 0x7e5c
> [    0.443642] [drm]   Encoders:
> [    0.443700] [drm]     DFP3: INTERNAL_LVTM1
> [    0.643372] [drm] fb mappable at 0xFC040000
> [    0.643432] [drm] vram apper at 0xFC000000
> [    0.643489] [drm] size 786432
> [    0.643546] [drm] fb depth is 8
> [    0.643603] [drm]    pitch is 1024
> [    0.643742] fbcon: radeondrmfb (fb0) is primary device
> [    0.663232] Console: switching to colour frame buffer device 128x48
> [    0.664818] fb0: radeondrmfb frame buffer device
> [    0.664837] drm: registered panic notifier
> [    0.664856] Slow work thread pool: Starting up
> [    0.664919] Slow work thread pool: Ready
> [    0.664940] [drm] Initialized radeon 2.5.0 20080528 for
> 0000:01:05.0 on minor 0
>
> Please note, that I'm only looking for "ring test succeeded" / "ring
> test failed", as I'm only using the KMS fb console on that system.
>
> Thanks for the fix,

Thanks for testing.  I've sent the patch to Dave.

Alex

>                            Torsten
>
