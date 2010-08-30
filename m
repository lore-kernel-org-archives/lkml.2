Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0H3IAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:00:39 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53056 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab0H3IAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MeC5yllUj+KmIbrqenkfeZNrvrzHQkKXMKZBBQm3WvEtKGSJHbMQ08puLL/pbLbn+w
         3ukSHYD/7DoYXKOj3UQuWIJ/ymfpiGIaZ77w0nYlglUh5F/D907+kGYwmQeEDJpANzY3
         myOhw/W5KIibpUaCNzlM+J6uvWwgTYSuYtkPA=
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 10:00:37 +0200
Message-ID: <AANLkTin4bz2ppciyRi4-PiYj7cb=Ad5DhdGoVde3evzF@mail.gmail.com>
Subject: 2.6.35.4 + rfcomm -> segfault
From: Martin Pirker <lkml.collector@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

given a Notebook with Bluetooth connection to mobile phone for GPRS Internet:

Aug 28 11:43:16 h kernel: [ 1520.976793] general protection fault:
0000 [#1] SMP
Aug 28 11:43:16 h kernel: [ 1520.976802] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/curre
nt_now
Aug 28 11:43:16 h kernel: [ 1520.976808] CPU 1
Aug 28 11:43:16 h kernel: [ 1520.976811] Modules linked in:
ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt sco bridge stp
bnep rfcomm l2cap joydev arc4 iw
lagn i915 iwlcore snd_hda_codec_intelhdmi snd_hda_codec_conexant
mac80211 drm_kms_helper snd_hda_intel snd_hda_codec drm btusb
snd_hwdep bluetooth cfg80211 snd_pcm p
smouse pcspkr snd_timer serio_raw thinkpad_acpi tpm_tis i2c_i801 snd
iTCO_wdt led_class tpm tpm_bios nvram e1000e soundcore
iTCO_vendor_support snd_page_alloc i2c_al
go_bit cfbcopyarea intel_agp cfbimgblt cfbfillrect video
Aug 28 11:43:16 h kernel: [ 1520.976897]
Aug 28 11:43:16 h kernel: [ 1520.976902] Pid: 4223, comm: wvdial Not
tainted 2.6.35.4 #1 5413A13/5413A13
Aug 28 11:43:16 h kernel: [ 1520.976907] RIP:
0010:[<ffffffff8147b0fd>]  [<ffffffff8147b0fd>]
sock_sendmsg+0xed/0x120
Aug 28 11:43:16 h kernel: [ 1520.976921] RSP: 0018:ffff880130ea78a8
EFLAGS: 00010246
Aug 28 11:43:16 h kernel: [ 1520.976925] RAX: dead4ead00002020 RBX:
ffff8801379c9140 RCX: 0000000000000004
Aug 28 11:43:16 h kernel: [ 1520.976929] RDX: ffff880130ea7a48 RSI:
ffff8801379c9140 RDI: ffff880130ea78a8
Aug 28 11:43:16 h kernel: [ 1520.976934] RBP: ffff880130ea7a18 R08:
0000000000000004 R09: ffff8801379c9140
Aug 28 11:43:16 h kernel: [ 1520.976938] R10: 0000000000000001 R11:
2222222222222222 R12: ffff880130ea7a48
Aug 28 11:43:16 h kernel: [ 1520.976942] R13: 0000000000000004 R14:
ffff880132695000 R15: ffff88012e0bc870
Aug 28 11:43:16 h kernel: [ 1520.976947] FS:  00007ff03bb66720(0000)
GS:ffff880002680000(0000) knlGS:0000000000000000
Aug 28 11:43:16 h kernel: [ 1520.976952] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Aug 28 11:43:16 h kernel: [ 1520.976956] CR2: 00007f5edee18000 CR3:
000000012bdfb000 CR4: 00000000000006e0
Aug 28 11:43:16 h kernel: [ 1520.976961] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 28 11:43:16 h kernel: [ 1520.976965] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 28 11:43:16 h kernel: [ 1520.976970] Process wvdial (pid: 4223,
threadinfo ffff880130ea6000, task ffff88013060bfc0)
Aug 28 11:43:16 h kernel: [ 1520.976974] Stack:
Aug 28 11:43:16 h kernel: [ 1520.976976]  0000000000015cc0
0000000000015cc0 0000000000000000 ffffffff00000001
Aug 28 11:43:16 h kernel: [ 1520.976984] <0> 0000000000000000
0000000000000000 0000000000000000 0000000000000000
Aug 28 11:43:16 h kernel: [ 1520.976993] <0> 0000000000000000
ffff88013060bfc0 0000000000000000 0000000000000931
Aug 28 11:43:16 h kernel: [ 1520.977003] Call Trace:
Aug 28 11:43:16 h kernel: [ 1520.977013]  [<ffffffff8147b171>]
kernel_sendmsg+0x41/0x60
Aug 28 11:43:16 h kernel: [ 1520.977022]  [<ffffffffa014314b>]
rfcomm_send_frame+0x3b/0x40 [rfcomm]
Aug 28 11:43:16 h kernel: [ 1520.977030]  [<ffffffffa01431b3>]
rfcomm_send_disc+0x63/0x70 [rfcomm]
Aug 28 11:43:16 h kernel: [ 1520.977038]  [<ffffffffa014429c>]
__rfcomm_dlc_close+0x25c/0x2b0 [rfcomm]
Aug 28 11:43:16 h kernel: [ 1520.977048]  [<ffffffff81583d05>] ?
mutex_lock_nested+0x35/0x40
Aug 28 11:43:16 h kernel: [ 1520.977055]  [<ffffffffa0144555>]
rfcomm_dlc_close+0x35/0x50 [rfcomm]
Aug 28 11:43:16 h kernel: [ 1520.977064]  [<ffffffffa0148a8e>]
rfcomm_tty_close+0x4e/0x100 [rfcomm]
Aug 28 11:43:16 h kernel: [ 1520.977071]  [<ffffffff813530ee>]
tty_release+0x17e/0x720
Aug 28 11:43:16 h kernel: [ 1520.977080]  [<ffffffff812be59e>] ?
do_raw_spin_unlock+0x5e/0xb0
Aug 28 11:43:16 h kernel: [ 1520.977088]  [<ffffffff81585aab>] ?
_raw_spin_unlock+0x2b/0x40
Aug 28 11:43:16 h kernel: [ 1520.977096]  [<ffffffffa0148d83>] ?
rfcomm_tty_open+0x243/0x330 [rfcomm]
Aug 28 11:43:16 h kernel: [ 1520.977105]  [<ffffffff810502c0>] ?
default_wake_function+0x0/0x20
Aug 28 11:43:16 h kernel: [ 1520.977111]  [<ffffffff813544be>]
tty_open+0x52e/0x600
Aug 28 11:43:16 h kernel: [ 1520.977121]  [<ffffffff8114fd27>]
chrdev_open+0xf7/0x210
Aug 28 11:43:16 h kernel: [ 1520.977128]  [<ffffffff81585aab>] ?
_raw_spin_unlock+0x2b/0x40
Aug 28 11:43:16 h kernel: [ 1520.977134]  [<ffffffff8114fc30>] ?
chrdev_open+0x0/0x210
Aug 28 11:43:16 h kernel: [ 1520.977141]  [<ffffffff8114a4f4>]
__dentry_open+0xe4/0x330
Aug 28 11:43:16 h kernel: [ 1520.977150]  [<ffffffff81286708>] ?
devcgroup_inode_permission+0x48/0x190
Aug 28 11:43:16 h kernel: [ 1520.977160]  [<ffffffff8125c34f>] ?
security_inode_permission+0x1f/0x30
Aug 28 11:43:16 h kernel: [ 1520.977167]  [<ffffffff8114a854>]
nameidata_to_filp+0x54/0x70
Aug 28 11:43:16 h kernel: [ 1520.977173]  [<ffffffff81158445>]
do_last+0x3e5/0x720
Aug 28 11:43:16 h kernel: [ 1520.977180]  [<ffffffff8115a867>]
do_filp_open+0x207/0x680
Aug 28 11:43:16 h kernel: [ 1520.977186]  [<ffffffff812be59e>] ?
do_raw_spin_unlock+0x5e/0xb0
Aug 28 11:43:16 h kernel: [ 1520.977193]  [<ffffffff81585aab>] ?
_raw_spin_unlock+0x2b/0x40
Aug 28 11:43:16 h kernel: [ 1520.977201]  [<ffffffff81165e6a>] ?
alloc_fd+0xfa/0x140
Aug 28 11:43:16 h kernel: [ 1520.977207]  [<ffffffff8114a2c9>]
do_sys_open+0x69/0x140
Aug 28 11:43:16 h kernel: [ 1520.977214]  [<ffffffff81585062>] ?
trace_hardirqs_on_thunk+0x3a/0x3f
Aug 28 11:43:16 h kernel: [ 1520.977220]  [<ffffffff8114a3e0>]
sys_open+0x20/0x30
Aug 28 11:43:16 h kernel: [ 1520.977229]  [<ffffffff8100b072>]
system_call_fastpath+0x16/0x1b
Aug 28 11:43:16 h kernel: [ 1520.977233] Code: ad 74 ff ff ff 44 89 ea
4c 89 e6 48 89 df e8 7b 0c de ff 85 c0 75 1a 48 8b 43 28 48 8d bd 90
fe ff ff 4c 89 e9 4c 89 e2 48 89 de <ff> 90 88 00 00 00 3d ef fd ff ff
74 16 48 8b 5d e8 4c 8b 65 f0
Aug 28 11:43:16 h kernel: [ 1520.977313] RIP  [<ffffffff8147b0fd>]
sock_sendmsg+0xed/0x120
Aug 28 11:43:16 h kernel: [ 1520.977319]  RSP <ffff880130ea78a8>
Aug 28 11:43:16 h kernel: [ 1520.977325] ---[ end trace b38fcf1132041c2a ]---


I remember this happened also on older kernels, but so far it happens
so rarely I didn't bother.
Maybe the stack trace is of help to you...

Martin
