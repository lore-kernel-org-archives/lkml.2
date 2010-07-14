Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab0GNTah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:30:37 -0400
Received: from nox2.protox.org ([95.130.11.66]:57460 "EHLO protox.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab0GNTag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:30:36 -0400
Message-ID: <4C3E103A.3030706@freedesktop.org>
Date: Wed, 14 Jul 2010 15:30:02 -0400
From: Jerome Glisse <glisse@freedesktop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Thunderbird/3.1
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
References: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>	<AANLkTilvbOb0n9l6F3EHwQg3VfNNmYB1BdFbzL2Cwg_P@mail.gmail.com>	<AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>	<AANLkTil58zbo28QL2ncTAXx9iHeQS20W8u0MuDgLaojj@mail.gmail.com>	<AANLkTim-yNCtMnxzzA8yJnD6CLkF2Mz-aA4E5qbYMBlz@mail.gmail.com>	<AANLkTim9EQ9nPISuH5wNsrAd8bHM-xBnpgqAi-W_ZCTi@mail.gmail.com> <AANLkTikjXiBoR3c5g6QaNfQKfX4vWUW8mt0AdomMa8at@mail.gmail.com>
In-Reply-To: <AANLkTikjXiBoR3c5g6QaNfQKfX4vWUW8mt0AdomMa8at@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------020904090508030502060707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020904090508030502060707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/14/2010 02:51 PM, Torsten Kaiser wrote:
> On Tue, Jul 13, 2010 at 9:10 PM, Alex Deucher<alexdeucher@gmail.com>  wrote:
>> On Tue, Jul 13, 2010 at 2:29 PM, Torsten Kaiser
>> <just.for.lkml@googlemail.com>  wrote:
>>> But the CP is still broken:
>>
>> Is this a regression?  If so, can you bisect it?
>>
>> Alex
>
> I bisected it to this commit:
>
> d594e46ace22afa1621254f6f669e65430048153 is the first bad commit
> commit d594e46ace22afa1621254f6f669e65430048153
> Author: Jerome Glisse<jglisse@redhat.com>
> Date:   Wed Feb 17 21:54:29 2010 +0000
>
>      drm/radeon/kms: simplify memory controller setup V2
>
>      Get rid of _location and use _start/_end also simplify the
>      computation of vram_start|end&  gtt_start|end. For R1XX-R2XX
>      we place VRAM at the same address of PCI aperture, those GPU
>      shouldn't have much memory and seems to behave better when
>      setup that way. For R3XX and newer we place VRAM at 0. For
>      R6XX-R7XX AGP we place VRAM before or after AGP aperture this
>      might limit to limit the VRAM size but it's very unlikely.
>      For IGP we don't change the VRAM placement.
>
>      Tested on (compiz,quake3,suspend/resume):
>      PCI/PCIE:RV280,R420,RV515,RV570,RV610,RV710
>      AGP:RV100,RV280,R420,RV350,RV620(RPB*),RV730
>      IGP:RS480(RPB*),RS690,RS780(RPB*),RS880
>
>      RPB: resume previously broken
>
>      V2 correct commit message to reflect more accurately the bug
>      and move VRAM placement to 0 for most of the GPU to avoid
>      limiting VRAM.
>
>      Signed-off-by: Jerome Glisse<jglisse@redhat.com>
>      Signed-off-by: Dave Airlie<airlied@redhat.com>
>
> :040000 040000 05c1e456fcf6565aa8711e4933807956d0055cca
> 792c6be2bd161a52500c5e8d685ee651cd5af07e M     drivers
>
> HTH, Torsten
>
>>> [    0.426931] Linux agpgart interface v0.103
>>> [    0.427092] [drm] Initialized drm 1.1.0 20060810
>>> [    0.427196] [drm] radeon defaulting to kernel modesetting.
>>> [    0.427255] [drm] radeon kernel modesetting enabled.
>>> [    0.427372] radeon 0000:01:05.0: PCI INT A ->  GSI 18 (level, low) ->  IRQ 18
>>> [    0.429659] [drm] initializing kernel modesetting (RS690 0x1002:0x791E).
>>> [    0.429817] [drm] register mmio base: 0xFE9F0000
>>> [    0.429876] [drm] register mmio size: 65536
>>> [    0.430457] ATOM BIOS: ATI
>>> [    0.430532] radeon 0000:01:05.0: VRAM: 32M 0xDE000000 - 0xDFFFFFFF (32M used)
>>> [    0.430592] radeon 0000:01:05.0: GTT: 512M 0xBE000000 - 0xDDFFFFFF
>>> [    0.430675] [drm] radeon: irq initialized.
>>> [    0.430737] mtrr: type mismatch for fc000000,2000000 old:
>>> write-back new: write-comb
>>> ining
>>> [    0.430811] [drm] Detected VRAM RAM=32M, BAR=32M
>>> [    0.430868] [drm] RAM width 128bits DDR
>>> [    0.431011] [TTM] Zone  kernel: Available graphics memory: 2010234 kiB.
>>> [    0.431070] [TTM] Initializing pool allocator.
>>> [    0.431147] [drm] radeon: 32M of VRAM memory ready
>>> [    0.431205] [drm] radeon: 512M of GTT memory ready.
>>> [    0.431266] [drm] GART: num cpu pages 131072, num gpu pages 131072
>>> [    0.434654] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
>>> [    0.441719] [drm] Loading RS690/RS740 Microcode
>>> [    0.441926] [drm] radeon: ring at 0x00000000BE000000
>>> [    0.577118] [drm:r100_ring_test] *ERROR* radeon: ring test failed
>>> (sracth(0x15E4)=0x
>>> CAFEDEAD)
>>> [    0.577192] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
>>> [    0.577252] radeon 0000:01:05.0: failled initializing CP (-22).
>>> [    0.577310] radeon 0000:01:05.0: Disabling GPU acceleration
>>> [    0.577440] [drm] radeon: cp finalized
>>> [    0.578078] [drm] Default TV standard: NTSC
>>> [    0.578314] [drm] Default TV standard: NTSC
>>> [    0.578590] [drm] Radeon Display Connectors
>>> [    0.578648] [drm] Connector 0:
>>> [    0.578706] [drm]   VGA
>>> [    0.578764] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
>>> 0x7e5c 0x7e4c
>>> [    0.578837] [drm]   Encoders:
>>> [    0.578894] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
>>> [    0.578952] [drm] Connector 1:
>>> [    0.579010] [drm]   S-video
>>> [    0.579067] [drm]   Encoders:
>>> [    0.579124] [drm]     TV1: INTERNAL_KLDSCP_DAC1
>>> [    0.579182] [drm] Connector 2:
>>> [    0.579239] [drm]   HDMI-A
>>> [    0.579297] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
>>> 0x7e4c 0x7e5c
>>> [    0.579369] [drm]   Encoders:
>>> [    0.579427] [drm]     DFP3: INTERNAL_LVTM1
>>> [    0.773375] [drm] fb mappable at 0xFC040000
>>> [    0.773434] [drm] vram apper at 0xFC000000
>>> [    0.773491] [drm] size 786432
>>> [    0.773549] [drm] fb depth is 8
>>> [    0.773606] [drm]    pitch is 1024
>>> [    0.773737] fbcon: radeondrmfb (fb0) is primary device
>>> [    0.793240] Console: switching to colour frame buffer device 128x48
>>> [    0.794833] fb0: radeondrmfb frame buffer device
>>> [    0.794852] drm: registered panic notifier
>>> [    0.794871] Slow work thread pool: Starting up
>>> [    0.794932] Slow work thread pool: Ready
>>> [    0.794953] [drm] Initialized radeon 2.5.0 20080528 for
>>> 0000:01:05.0 on minor 0
>>>
>>>
>>> Torsten
>>>
>>

Does the attached patch works ? (try to change the if 0 to if 1 too

Cheers,
Jerome

--------------020904090508030502060707
Content-Type: text/plain;
 name="0001-HACK-RS690.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-HACK-RS690.patch"

>From c699536948731a37372dbc12062559265fcc2f3c Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Wed, 14 Jul 2010 15:28:53 -0400
Subject: [PATCH] HACK RS690

---
 drivers/gpu/drm/radeon/rs690.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 23676b6..9dd9c6d 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -162,7 +162,15 @@ void rs690_mc_init(struct radeon_device *rdev)
 	rs690_pm_info(rdev);
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
 	radeon_vram_location(rdev, &rdev->mc, base);
-	radeon_gtt_location(rdev, &rdev->mc);
+//	radeon_gtt_location(rdev, &rdev->mc);
+#if 0
+	mc->gtt_start = 0;
+#else
+	mc->gtt_start = 0xB0000000;
+#endif
+	mc->gtt_end = mc->gtt_start + mc->gtt_size - 1;
+	dev_info(rdev->dev, "GTT: %lluM 0x%08llX - 0x%08llX\n",
+			mc->gtt_size >> 20, mc->gtt_start, mc->gtt_end);
 	radeon_update_bandwidth_info(rdev);
 }
 
-- 
1.7.1


--------------020904090508030502060707--
