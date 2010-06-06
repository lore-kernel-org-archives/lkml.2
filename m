Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab0FFP6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:58:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0FFP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mAHL+bqRhJWyZn10jxeFcgnyFN8yDuqx3B7L9Z9+vcy+HzGX39kD3cm/kjdNhVlX7Y
         6fcmGjGno7LZbpLu3qZ95f2HWATAGESkYMPZSz/bDicHHHwtCnTjnxwqsMlvBSNMPzpx
         9tTXYBOLkKj4QYEfDM0oZKB7OQXKEG64zY9aY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
Date: Sun, 6 Jun 2010 17:58:00 +0200
Message-ID: <AANLkTimZkT3EPYFcPfwJUyn2-lGI4wRk4PodRyePkIbI@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 4:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, 6 Jun 2010, Torsten Kaiser wrote:
>>
>> The first problem that shows up is, that after the KMS switches to the
>> correct video mode (1280x1024 for an DVI attached LCD), the display
>> begins to flicker. Every 1..2 seconds (guesstimated) the display turns
>> off and on again. Something in the new powersaving?
>
> Or maybe a borderline display timing that the display has trouble syncing
> up with?
>

Doesn't seems so.
On both kernels the fb console switches to 1280x1024@59.9 according to
the monitor and after starting X this is switched to 1280x1024@60.2.
(A new try with 2.6.35-rc2 got me to the weave pattern from X before
the ata OOPS killed the machine)

I tried both kernels with drm.debug=15 to get more information, but I
can't see anything suspicious.
The modelines get renumbered, but still look the same.

But I was wrong about the 1..2 seconds: The switch-off-intervall is ~10 seconds.

Here are the parts where the kernel switches to 1280x1024:

>From 2.6.34:
[    2.269082] [drm:drm_setup_crtcs],
[    2.269084] [drm:drm_enable_connectors], connector 10 enabled? yes
[    2.269086] [drm:drm_enable_connectors], connector 13 enabled? yes
[    2.269087] [drm:drm_enable_connectors], connector 14 enabled? no
[    2.269089] [drm:drm_target_preferred], looking for cmdline mode on
connector 10
[    2.269093] [drm:drm_target_preferred], found mode 1280x1024
[    2.269095] [drm:drm_target_preferred], looking for cmdline mode on
connector 13
[    2.269097] [drm:drm_target_preferred], found mode 1280x1024
[    2.269098] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    2.269103] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 7
[    2.269104] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 8
[    2.273467] [drm] fb mappable at 0xE00C0000
[    2.277657] [drm] vram apper at 0xE0000000
[    2.281789] [drm] size 5242880
[    2.284852] [drm] fb depth is 24
[    2.288086] [drm]    pitch is 5120
[    2.291609] fbcon: radeondrmfb (fb0) is primary device
[    2.297424] [drm:drm_crtc_helper_set_config],
[    2.297426] [drm:drm_crtc_helper_set_config], crtc:
ffff88011f65a000 7 fb: ffff88007f190900 connectors: ffff8800077ef080
num_connectors: 1 (x, y) (0, 0)
[    2.297432] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    2.297434] [drm:drm_crtc_helper_set_config], modes are different,
full mode set
[    2.297436] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
0 0 0 0 0 0 0 0x0 0x0
[    2.297439] [drm:drm_mode_debug_printmodeline], Modeline
41:"1280x1024" 0 109000 1280 1368 1496 1712 1024 1027 1034 1063 0x0
0x6
[    2.297444] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88011f65a000
[    2.297446] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88011f65b000
[    2.297449] [drm:drm_crtc_helper_set_config], attempting to set
mode from userspace
[    2.297451] [drm:drm_mode_debug_printmodeline], Modeline
41:"1280x1024" 0 109000 1280 1368 1496 1712 1024 1027 1034 1063 0x0
0x6
[    2.297456] [drm:radeon_encoder_set_active_device], setting active
device to 00000001 from 00000001 00000001 for encoder 1
[    2.297463] [drm:radeon_legacy_primary_dac_dpms],
[    2.297465] [drm:radeon_legacy_tv_dac_dpms],
[    2.297470] [drm:radeon_crtc_set_base],
[    2.297479] [drm:r100_bandwidth_update], GRPH_BUFFER_CNTL from to 20007c7c
[    2.297481] [drm:radeon_set_crtc_timing],
[    2.297485] [drm:radeon_set_pll],
[    2.297487] [drm:radeon_compute_pll_legacy], PLL freq 109000 2 1023
[    2.297819] [drm:radeon_set_pll], dc=10900, fd=109, rd=9, pd=3
[    2.297829] [drm:radeon_set_pll], Wrote: 0x00000009 0x0004006d
0x00000000 (0x00008f00)
[    2.297832] [drm:radeon_set_pll], Wrote: rd=9, fd=109, pd=4
[    2.347825] [drm:drm_crtc_helper_set_mode], DAC-9: set mode 1280x1024 29
[    2.347827] [drm:radeon_legacy_primary_dac_mode_set],
[    2.347852] [drm:radeon_legacy_primary_dac_dpms],
[    2.347855] [drm:radeon_legacy_tv_dac_dpms],
[    2.347859] [drm:drm_crtc_helper_set_config],
[    2.347860] [drm:drm_crtc_helper_set_config], crtc:
ffff88011f65b000 8 fb: ffff88007f190900 connectors: ffff8800077ef060
num_connectors: 1 (x, y) (0, 0)
[    2.347865] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    2.347866] [drm:drm_crtc_helper_set_config], modes are different,
full mode set
[    2.347869] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
0 0 0 0 0 0 0 0x0 0x0
[    2.347872] [drm:drm_mode_debug_printmodeline], Modeline
42:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48
0x5
[    2.347876] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88011f65a000
[    2.347878] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88011f65b000
[    2.347881] [drm:drm_crtc_helper_set_config], attempting to set
mode from userspace
[    2.347883] [drm:drm_mode_debug_printmodeline], Modeline
42:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48
0x5
[    2.347887] [drm:radeon_encoder_set_active_device], setting active
device to 00000008 from 00000008 00000018 for encoder 2
[    2.347892] [drm:radeon_legacy_tmds_int_dpms],
[    2.347894] [drm:radeon_legacy_tv_dac_dpms],
[    2.347899] [drm:radeon_crtc_set_base],
[    2.347905] [drm:r100_bandwidth_update], GRPH_BUFFER_CNTL from to 20007c7c
[    2.347909] [drm:r100_bandwidth_update], GRPH2_BUFFER_CNTL from to 20007c7c
[    2.347911] [drm:radeon_set_crtc_timing],
[    2.347913] [drm:radeon_set_pll],
[    2.347915] [drm:radeon_compute_pll_legacy], PLL freq 108000 2 1023
[    2.348119] [drm:radeon_set_pll], dc=10800, fd=16, rd=2, pd=2
[    2.348129] [drm:radeon_set_pll], Wrote2: 0x00000002 0x00010010
0x00000000 (0x00008c00)
[    2.348131] [drm:radeon_set_pll], Wrote2: rd=2, fd=16, pd=1
[    2.398137] [drm:drm_crtc_helper_set_mode], TMDS-12: set mode 1280x1024 2a
[    2.398139] [drm:radeon_legacy_tmds_int_mode_set],
[    2.398180] [drm:radeon_legacy_tmds_int_dpms],
[    2.398183] [drm:radeon_legacy_tv_dac_dpms],
[    2.404637] [drm:drm_crtc_helper_set_config],
[    2.404639] [drm:drm_crtc_helper_set_config], crtc:
ffff88011f65a000 7 fb: ffff88007f190900 connectors: ffff8800077ef080
num_connectors: 1 (x, y) (0, 0)
[    2.404644] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88011f65a000
[    2.404646] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88011f65b000
[    2.404649] [drm:drm_crtc_helper_set_config],
[    2.404650] [drm:drm_crtc_helper_set_config], crtc:
ffff88011f65b000 8 fb: ffff88007f190900 connectors: ffff8800077ef060
num_connectors: 1 (x, y) (0, 0)
[    2.404655] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88011f65a000
[    2.404657] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88011f65b000
[    2.411530] Console: switching to colour frame buffer device 160x64
[    2.411534] [drm:drm_crtc_helper_set_config],
[    2.411535] [drm:drm_crtc_helper_set_config], crtc:
ffff88011f65a000 7 fb: ffff88007f190900 connectors: ffff8800077ef080
num_connectors: 1 (x, y) (0, 0)
[    2.411539] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88011f65a000
[    2.411541] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88011f65b000
[    2.411543] [drm:drm_crtc_helper_set_config],
[    2.411544] [drm:drm_crtc_helper_set_config], crtc:
ffff88011f65b000 8 fb: ffff88007f190900 connectors: ffff8800077ef060
num_connectors: 1 (x, y) (0, 0)
[    2.411548] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88011f65a000
[    2.411550] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88011f65b000
[    2.424139] fb0: radeondrmfb frame buffer device
[    2.428777] registered panic notifier
[    2.432485] [drm] Initialized radeon 2.3.0 20080528 for
0000:01:00.0 on minor 0

And from 2.6.35-rc2:
[    3.656308] [drm:drm_setup_crtcs],
[    3.659836] [drm:drm_enable_connectors], connector 10 enabled? yes
[    3.666075] [drm:drm_enable_connectors], connector 13 enabled? yes
[    3.672309] [drm:drm_enable_connectors], connector 14 enabled? no
[    3.678434] [drm:drm_target_preferred], looking for cmdline mode on
connector 10
[    3.685889] [drm:drm_target_preferred], found mode 1280x1024
[    3.691601] [drm:drm_target_preferred], looking for cmdline mode on
connector 13
[    3.699023] [drm:drm_target_preferred], found mode 1280x1024
[    3.704748] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    3.711241] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 7
[    3.717884] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 8
[    3.729097] [drm] fb mappable at 0xE00C0000
[    3.733313] [drm] vram apper at 0xE0000000
[    3.737414] [drm] size 5242880
[    3.740497] [drm] fb depth is 24
[    3.743735] [drm]    pitch is 5120
[    3.747239] fbcon: radeondrmfb (fb0) is primary device
[    3.753040] [drm:drm_crtc_helper_set_config],
[    3.753042] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40c000 7 fb: ffff8800076f28b0 connectors: ffff88007f43f920
num_connectors: 1 (x, y) (0, 0)
[    3.753047] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    3.753048] [drm:drm_crtc_helper_set_config], modes are different,
full mode set
[    3.753050] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
0 0 0 0 0 0 0 0x0 0x0
[    3.753053] [drm:drm_mode_debug_printmodeline], Modeline
40:"1280x1024" 0 109000 1280 1368 1496 1712 1024 1027 1034 1063 0x0
0x6
[    3.753057] [drm:drm_crtc_helper_set_config], encoder changed, full
mode switch
[    3.753059] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    3.753060] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.753062] [drm:drm_crtc_helper_set_config], attempting to set
mode from userspace
[    3.753064] [drm:drm_mode_debug_printmodeline], Modeline
40:"1280x1024" 0 109000 1280 1368 1496 1712 1024 1027 1034 1063 0x0
0x6
[    3.753070] [drm:radeon_encoder_set_active_device], setting active
device to 00000001 from 00000001 00000001 for encoder 1
[    3.753076] [drm:radeon_legacy_primary_dac_dpms],
[    3.753079] [drm:radeon_legacy_tv_dac_dpms],
[    3.753082] [drm:radeon_legacy_tmds_int_dpms],
[    3.753087] [drm:radeon_crtc_set_base],
[    3.753096] [drm:r100_bandwidth_update], GRPH_BUFFER_CNTL from to 20007c7c
[    3.753098] [drm:radeon_set_crtc_timing],
[    3.753102] [drm:radeon_set_pll],
[    3.753104] [drm:radeon_compute_pll_legacy], PLL freq 109000 2 1023
[    3.753436] [drm:radeon_set_pll], dc=10900, fd=109, rd=9, pd=3
[    3.753445] [drm:radeon_set_pll], Wrote: 0x00000009 0x0004006d
0x00000000 (0x00008f00)
[    3.753447] [drm:radeon_set_pll], Wrote: rd=9, fd=109, pd=4
[    3.803450] [drm:drm_crtc_helper_set_mode], DAC-9: set mode 1280x1024 28
[    3.803452] [drm:radeon_legacy_primary_dac_mode_set],
[    3.803476] [drm:radeon_legacy_primary_dac_dpms],
[    3.803479] [drm:radeon_legacy_tv_dac_dpms],
[    3.803483] [drm:radeon_legacy_tmds_int_dpms],
[    3.803487] [drm:drm_crtc_helper_set_config],
[    3.803488] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40d000 8 fb: ffff8800076f28b0 connectors: ffff88007f43f940
num_connectors: 1 (x, y) (0, 0)
[    3.803492] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    3.803494] [drm:drm_crtc_helper_set_config], modes are different,
full mode set
[    3.803496] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
0 0 0 0 0 0 0 0x0 0x0
[    3.803499] [drm:drm_mode_debug_printmodeline], Modeline
41:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48
0x5
[    3.803503] [drm:drm_crtc_helper_set_config], encoder changed, full
mode switch
[    3.803505] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.803507] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    3.803508] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    3.803510] [drm:drm_crtc_helper_set_config], attempting to set
mode from userspace
[    3.803512] [drm:drm_mode_debug_printmodeline], Modeline
41:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48
0x5
[    3.803516] [drm:radeon_encoder_set_active_device], setting active
device to 00000008 from 00000008 00000018 for encoder 2
[    3.803520] [drm:radeon_legacy_tmds_int_dpms],
[    3.803522] [drm:radeon_legacy_tv_dac_dpms],
[    3.803527] [drm:radeon_crtc_set_base],
[    3.803534] [drm:r100_bandwidth_update], GRPH_BUFFER_CNTL from to 20007c7c
[    3.803537] [drm:r100_bandwidth_update], GRPH2_BUFFER_CNTL from to 20007c7c
[    3.803538] [drm:radeon_set_crtc_timing],
[    3.803541] [drm:radeon_set_pll],
[    3.803542] [drm:radeon_compute_pll_legacy], PLL freq 108000 2 1023
[    3.803747] [drm:radeon_set_pll], dc=10800, fd=16, rd=2, pd=2
[    3.803757] [drm:radeon_set_pll], Wrote2: 0x00000002 0x00010010
0x00000000 (0x00008c00)
[    3.803759] [drm:radeon_set_pll], Wrote2: rd=2, fd=16, pd=1
[    3.853764] [drm:drm_crtc_helper_set_mode], TMDS-12: set mode 1280x1024 29
[    3.853766] [drm:radeon_legacy_tmds_int_mode_set],
[    3.853807] [drm:radeon_legacy_tmds_int_dpms],
[    3.853810] [drm:radeon_legacy_tv_dac_dpms],
[    3.853835] [drm:drm_crtc_helper_set_config],
[    3.853836] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40c000 7 fb: ffff8800076f28b0 connectors: ffff88007f43f920
num_connectors: 1 (x, y) (0, 0)
[    3.853841] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.853843] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    3.853845] [drm:drm_crtc_helper_set_config],
[    3.853846] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40d000 8 fb: ffff8800076f28b0 connectors: ffff88007f43f940
num_connectors: 1 (x, y) (0, 0)
[    3.853850] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.853852] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    3.860309] [drm:drm_crtc_helper_set_config],
[    3.860310] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40c000 7 fb: ffff8800076f28b0 connectors: ffff88007f43f920
num_connectors: 1 (x, y) (0, 0)
[    3.860314] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.860316] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    3.860319] [drm:drm_crtc_helper_set_config],
[    3.860320] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40d000 8 fb: ffff8800076f28b0 connectors: ffff88007f43f940
num_connectors: 1 (x, y) (0, 0)
[    3.860324] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.860326] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    3.867138] Console: switching to colour frame buffer device 160x64
[    3.867142] [drm:drm_crtc_helper_set_config],
[    3.867143] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40c000 7 fb: ffff8800076f28b0 connectors: ffff88007f43f920
num_connectors: 1 (x, y) (0, 0)
[    3.867147] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.867149] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    3.867151] [drm:drm_crtc_helper_set_config],
[    3.867152] [drm:drm_crtc_helper_set_config], crtc:
ffff88007f40d000 8 fb: ffff8800076f28b0 connectors: ffff88007f43f940
num_connectors: 1 (x, y) (0, 0)
[    3.867156] [drm:drm_crtc_helper_set_config], setting connector 10
crtc to ffff88007f40c000
[    3.867158] [drm:drm_crtc_helper_set_config], setting connector 13
crtc to ffff88007f40d000
[    4.559861] fb0: radeondrmfb frame buffer device
[    4.566873] drm: registered panic notifier
[    4.573135] [drm] Initialized radeon 2.4.0 20080528 for
0000:01:00.0 on minor 0
