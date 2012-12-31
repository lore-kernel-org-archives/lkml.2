Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab2LaOZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 09:25:39 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:38199 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2LaOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 09:25:37 -0500
MIME-Version: 1.0
Date: Mon, 31 Dec 2012 15:25:36 +0100
Message-ID: <CAHOpdHXwLrKmyfUQbz0uhp26JHnWBuKUPgH7KjyU1=WgHw1Frg@mail.gmail.com>
Subject: pm-suspend not waking up properly
From: =?ISO-8859-1?Q?Bj=F6rn_Christoph?= <einkaufenbc09@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I used uswusp till now and it worked for my old HW configuration. Now
I updated to a new

I'm running Ubuntu 12.04 with a self-compiled Linux 3.7.0 kernel (uname -a):
Linux linux 3.7.0-custom #2 SMP Sat Dec 22 15:07:12 CET 2012 x86_64
x86_64 x86_64 GNU/Linux

Mainboard is (dmesg | grep Gigabyte):
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by
O.E.M./F2A85X-D3H, BIOS F1 10/09/2012

Processor is an AMD A4-5300 with a microcode update (cat /proc/cpuinfo):
processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 21
model           : 16
model name      : AMD A4-5300 APU with Radeon(tm) HD Graphics
stepping        : 1
microcode       : 0x6001119

"s2ram" would not work with this mainboard anymore. I then used "s2ram
-f -a 1" and that worked.

Now s2ram is deprecated so I used "pm-suspend" but the PC doesnt wake
up properly. Monitor is black, network is down but keyboard lights up
when i press the CAPSLOCK button etc.

So i took a log to see what happens when PC enters suspend mode:
---------
Mon Dec 24 23:10:02 CET 2012: Running hooks for suspend.
Running hook /usr/lib/pm-utils/sleep.d/000kernel-change suspend suspend:

/usr/lib/pm-utils/sleep.d/000kernel-change suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00logging suspend suspend:
Linux linux 3.7.0-custom #2 SMP Sat Dec 22 15:07:12 CET 2012 x86_64
x86_64 x86_64 GNU/Linux
Module                  Size  Used by
xfs                   885075  1
libcrc32c              12644  1 xfs
ext2                   72820  2
kvm_amd                59833  0
kvm                   443029  1 kvm_amd
snd_hda_codec_hdmi     36804  1
snd_hda_intel          43738  0
snd_hda_codec         140017  2 snd_hda_codec_hdmi,snd_hda_intel
snd_hwdep              13563  1 snd_hda_codec
snd_pcm                97486  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
snd_timer              29532  1 snd_pcm
snd                    78958  6
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore              15047  1 snd
snd_page_alloc         18710  2 snd_hda_intel,snd_pcm
microcode              22893  0
i2c_piix4              13266  0
serio_raw              13215  0
k10temp                13126  0
mac_hid                13205  0
lp                     17759  0
parport                46354  1 lp
dm_crypt               22800  7
pata_jmicron           12758  0
ghash_clmulni_intel    13259  0
aesni_intel            55399  15
ablk_helper            13597  1 aesni_intel
cryptd                 20360  10 ghash_clmulni_intel,aesni_intel,ablk_helper
lrw                    13286  1 aesni_intel
aes_x86_64             17255  1 aesni_intel
xts                    12914  1 aesni_intel
gf128mul               14951  2 lrw,xts
radeon                929563  1
r8169                  67571  0
ttm                    83223  1 radeon
drm_kms_helper         49196  1 radeon
drm                   280816  3 radeon,ttm,drm_kms_helper
i2c_algo_bit           13413  1 radeon
             total       used       free     shared    buffers     cached
Mem:       3414116    3302128     111988          0      13144    2664148
-/+ buffers/cache:     624836    2789280
Swap:      1953788          0    1953788

/usr/lib/pm-utils/sleep.d/00logging suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00powersave suspend suspend:

/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
Running hook /etc/pm/sleep.d/10_grub-common suspend suspend:

/etc/pm/sleep.d/10_grub-common suspend suspend: success.
Running hook /etc/pm/sleep.d/10_unattended-upgrades-hibernate suspend suspend:

/etc/pm/sleep.d/10_unattended-upgrades-hibernate suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend:
Having NetworkManager put all interaces to sleep...Failed.

/usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/75modules suspend suspend:

/usr/lib/pm-utils/sleep.d/75modules suspend suspend: not applicable.
Running hook /usr/lib/pm-utils/sleep.d/90clock suspend suspend:

/usr/lib/pm-utils/sleep.d/90clock suspend suspend: not applicable.
Running hook /usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend:

/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/95hdparm-apm suspend suspend:

/usr/lib/pm-utils/sleep.d/95hdparm-apm suspend suspend: not applicable.
Running hook /usr/lib/pm-utils/sleep.d/95led suspend suspend:

/usr/lib/pm-utils/sleep.d/95led suspend suspend: not applicable.
Running hook /usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend:
Kernel modesetting video driver detected, not using quirks.

/usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/99video suspend suspend:
kernel.acpi_video_flags = 0

/usr/lib/pm-utils/sleep.d/99video suspend suspend: success.
Mon Dec 24 23:10:03 CET 2012: performing suspend
------------

Can someone help?

Thanks!
