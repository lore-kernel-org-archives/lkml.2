Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1CIPjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:39:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1CIPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:39:52 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=K6WpieSMszAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uPZGp_yHQRre6w04UYgA:9 a=a0HKuKV7mtjOzzjUa-P5yyH8nxgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [BUG] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 10:39:49 -0500
Message-ID: <1299685189.15854.182.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure who to send this to, but last night on v2.6.38-rc8 ktest
triggered this warning:


[   32.062538] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
[   32.071305] PM: Adding info for No Bus:timer
[   32.075864] PM: Adding info for platform:snd_dummy.0^M
[   32.081232] PM: Adding info for No Bus:card0
[   32.085853] PM: Adding info for No Bus:pcmC0D0p
[   32.090650] PM: Adding info for No Bus:pcmC0D0c
[   32.095667] PM: Adding info for No Bus:dsp
[   32.099918] ------------[ cut here ]------------
[   32.104531] WARNING: at /home/rostedt/work/autotest/nobackup/linux-test.git/fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
[   32.115379] Hardware name:         
[   32.118859] sysfs: cannot create duplicate filename '/dev/char/14:4'
[   32.125197] Modules linked in:
[   32.128255] Pid: 1, comm: swapper Not tainted 2.6.38-rc8-test #1
[   32.134247] Call Trace:^M
[   32.136693]  [<c044d095>] ? warn_slowpath_common+0x7c/0x91
[   32.142168]  [<c0552d35>] ? sysfs_add_one+0x83/0x95
[   32.147036]  [<c0552d35>] ? sysfs_add_one+0x83/0x95
[   32.151904]  [<c044d135>] ? warn_slowpath_fmt+0x33/0x35
[   32.157120]  [<c0552d35>] ? sysfs_add_one+0x83/0x95
[   32.161989]  [<c055393d>] ? sysfs_do_create_link+0xdf/0x181^M
[   32.167550]  [<c073637f>] ? vsnprintf+0x22c/0x266
[   32.172246]  [<c0553a0f>] ? sysfs_create_link+0x17/0x1c
[   32.177462]  [<c0950ce4>] ? device_add+0x183/0x573
[   32.182245]  [<c0958474>] ? device_pm_init+0x5d/0x61
[   32.187200]  [<c09510eb>] ? device_register+0x17/0x1a
[   32.192243]  [<c0951165>] ? device_create_vargs+0x77/0x98
[   32.197631]  [<c09511b3>] ? device_create+0x2d/0x2f
[   32.202501]  [<c0dc5caa>] ? sound_insert_unit+0x1ba/0x1d5
[   32.207891]  [<c0dc5e8e>] ? register_sound_special_device+0x103/0x11c
[   32.214319]  [<c0dd7875>] ? snd_register_oss_device+0x10a/0x169
[   32.220229]  [<c0de6cd6>] ? register_oss_dsp+0x62/0xb5
[   32.225358]  [<c046b95c>] ? sched_clock_cpu+0x16a/0x17a
[   32.230575]  [<c04778f2>] ? mark_held_locks+0x43/0x5b
[   32.235616]  [<c0fa124c>] ? __mutex_lock_common+0x39f/0x3c7
[   32.241177]  [<c04776d2>] ? mark_lock+0x1e/0x1fb
[   32.245787]  [<c04778f2>] ? mark_held_locks+0x43/0x5b
[   32.250838]  [<c0fa0cff>] ? __mutex_unlock_slowpath+0x137/0x153
[   32.256745]  [<c0de6d69>] ? snd_pcm_oss_register_minor+0x40/0xe3
[   32.262737]  [<c0fa0d28>] ? mutex_unlock+0xd/0xf
[   32.267345]  [<c0dd96b7>] ? snd_timer_dev_register+0x10d/0x117
[   32.273165]  [<c0dd6db9>] ? snd_device_register+0x67/0xd2
[   32.278551]  [<c07363d5>] ? sprintf+0x1c/0x1e^M
[   32.282900]  [<c0de2db7>] ? snd_pcm_timer_init+0xba/0xef
[   32.288201]  [<c0ddb426>] ? snd_pcm_dev_register+0x1e8/0x224
[   32.293848]  [<c0951000>] ? device_add+0x49f/0x573
[   32.298630]  [<c0dd6d32>] ? snd_device_register_all+0x5e/0x7e
[   32.304363]  [<c09511b3>] ? device_create+0x2d/0x2f
[   32.309230]  [<c0dd32d3>] ? snd_card_register+0x92/0x1af
[   32.314531]  [<c0f87b9b>] ? snd_dummy_probe+0x322/0x3b2
[   32.319745]  [<c0953f57>] ? platform_drv_probe+0x14/0x16
[   32.325046]  [<c0953154>] ? driver_probe_device+0x116/0x1ed
[   32.330606]  [<c073b414>] ? do_raw_spin_unlock+0x8f/0x94
[   32.335906]  [<c09532c5>] ? __device_attach+0x2f/0x33^M
[   32.340946]  [<c09524ab>] ? bus_for_each_drv+0x44/0x6e
[   32.346073]  [<c095334e>] ? device_attach+0x61/0x7e^M
[   32.350941]  [<c0953296>] ? __device_attach+0x0/0x33
[   32.355895]  [<c09522e8>] ? bus_probe_device+0x23/0x38
[   32.361023]  [<c0950f61>] ? device_add+0x400/0x573
[   32.365805]  [<c0730ac4>] ? kobject_set_name_vargs+0x46/0x4c
[   32.371453]  [<c0954624>] ? platform_device_add+0x139/0x182
[   32.377015]  [<c095487d>] ? platform_device_register_resndata+0x4f/0x65
[   32.383616]  [<c17e2210>] ? alsa_card_dummy_init+0xcc/0x121
[   32.389177]  [<c0403096>] ? do_one_initcall+0x8c/0x161
[   32.394305]  [<c17e2144>] ? alsa_card_dummy_init+0x0/0x121
[   32.399780]  [<c17843cf>] ? kernel_init+0x12c/0x1c2
[   32.404646]  [<c17842a3>] ? kernel_init+0x0/0x1c2
[   32.409340]  [<c040a8c2>] ? kernel_thread_helper+0x6/0x10
[   32.414782] ---[ end trace 5d9e7ab86ca08fa1 ]---
[   32.419772] PM: Adding info for No Bus:controlC0
[   32.424867] PM: Adding info for isa:es18xx.0
[   32.429167] PM: Removing info for isa:es18xx.0


This was for a 386 build. I could give a .config and full dmesg if
needed.

Thanks,

-- Steve



