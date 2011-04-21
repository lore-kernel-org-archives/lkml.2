Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1DURAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:00:38 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:36447 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1DURAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:00:37 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 13:00:36 EDT
Message-ID: <4DB05C13.2080708@xs4all.nl>
Date: Thu, 21 Apr 2011 18:32:19 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.38.3 BUG?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What can be said about the BUG logging below?
Cause?  (hw/sw)
Known?



BUG: unable to handle kernel paging request at ffffffffffffff7f
IP: [<ffffffff810c90e2>] __destroy_inode+0x62/0x90
PGD 14d4067 PUD 14d5067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 0
Modules linked in: eeprom f71882fg sunrpc cpufreq_ondemand powernow_k8
mperf binfmt_misc budget_av saa7146_vv videodev videobuf_dma_sg
videobuf_core tua6100 budget_core saa7146 fan ttpci_eeprom dvb_pll
snd_hda_codec_hdmi tda10021 tda10023 tda8261 tda1004x stb0899 sg thermal
button processor snd_hda_codec_realtek stv0299 dvb_core i2c_piix4
k10temp evdev snd_hda_intel snd_hda_codec snd_seq snd_seq_device snd_pcm
snd_timer snd snd_page_alloc usbhid hid ehci_hcd ata_generic ohci_hcd
sr_mod fbcon radeon font bitblit softcursor ttm drm_kms_helper
cfbcopyarea cfbimgblt cfbfillrect [last unloaded: scsi_wait_scan]

Pid: 13848, comm: mandb Not tainted 2.6.38.3 #4 Unknow Unknow/RS780-SB700
RIP: 0010:[<ffffffff810c90e2>]  [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
RSP: 0018:ffff88009c39de88  EFLAGS: 00010282
RAX: ffffffffffffff7e RBX: ffff880002e7a0f0 RCX: 0000000000007540
RDX: 0000000000000003 RSI: ffff880002e7a138 RDI: ffffffffffffff7f
RBP: ffff880002e7a0f0 R08: ffdf185f81dc4e03 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801212e0080
R13: ffff8801212e0cdc R14: ffff88012fcdf4c0 R15: ffff88009c11e3d0
FS:  00007f26d24e2720(0000) GS:ffff8800bfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffff7f CR3: 00000000023d7000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mandb (pid: 13848, threadinfo ffff88009c39c000, task
ffff88012d85b710)
Stack:
 ffff880002e7a0f0 ffffffff810c9123 ffff8801212e0c80 ffffffff810c4320
 ffff8801212e0c80 ffff880002e7a0f0 ffff8801212e0080 ffffffff810c6119
 0000000000000008 ffff88009c11e3c0 0000000000000008 ffff880002e7a0f0
Call Trace:
 [<ffffffff810c9123>] ? destroy_inode+0x13/0x50
 [<ffffffff810c4320>] ? d_kill+0xe0/0x140
 [<ffffffff810c6119>] ? dput+0xc9/0x190
 [<ffffffff810b284a>] ? fput+0x16a/0x220
 [<ffffffff810af0a9>] ? filp_close+0x59/0x80
 [<ffffffff810af17d>] ? sys_close+0xad/0x110
 [<ffffffff8100237b>] ? system_call_fastpath+0x16/0x1b
Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff 74 0a f0 ff 0f 0f 94 c0 84 c0 75
32 65 ff 0c 25 8c e8 00 00 5b c3 48 85 ff 0f 1f 44 00 00 74 cc <f0> ff
0f 0f 94 c0 84 c0 66 0f 1f 44 00 00 74 bc e8 b9 fc fd ff
RIP  [<ffffffff810c90e2>] __destroy_inode+0x62/0x90
 RSP <ffff88009c39de88>
CR2: ffffffffffffff7f
---[ end trace e307d50a77eb9f44 ]---
[root@recorder xf86-video-ati]# uname -a
Linux recorder.hierzo 2.6.38.3 #4 SMP PREEMPT Sat Apr 16 15:50:24 CEST
2011 x86_64 x86_64 x86_64 GNU/Linux
[root@recorder xf86-video-ati]#


This is what I found in the ssh sesion:

[root@recorder xf86-video-ati]#
Message from syslogd@recorder at Apr 21 03:36:44 ...
 kernel:Oops: 0002 [#1] PREEMPT SMP

Message from syslogd@recorder at Apr 21 03:36:44 ...
 kernel:last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map

Message from syslogd@recorder at Apr 21 03:36:44 ...
 kernel:Stack:

Message from syslogd@recorder at Apr 21 03:36:44 ...
 kernel:Call Trace:

Message from syslogd@recorder at Apr 21 03:36:44 ...
 kernel:Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff 74 0a f0 ff 0f 0f 94 c0
84 c0 75 32 65 ff 0c 25 8c e8 00 00 5b c3 48 85 ff 0f 1f 44 00 00 74 cc
<f0> ff 0f 0f 94 c0 84 c0 66 0f 1f 44 00 00 74 bc e8 b9 fc fd ff

Message from syslogd@recorder at Apr 21 03:36:44 ...
 kernel:CR2: ffffffffffffff7f





Udo
