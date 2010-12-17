Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0LRAEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:04:16 -0500
Received: from mx.mylinuxtime.de ([80.190.48.209]:59625 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab0LRAEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:04:14 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2010 19:04:14 EST
X-Spam-ASN: 
Date: Sat, 18 Dec 2010 00:55:26 +0100
From: Christian Hesse <mail@earthworm.de>
To: linux-kernel@vger.kernel.org
Cc: thunar-dev@xfce.org
Subject: Thunar crashes kernel
Message-ID: <20101218005526.177e1617@leda.vpn.lugor.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Envelope-From: <mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo everybody,

I'm running kernel 2.6.36.2 from Arch Linux, patched with autogroup. It ran
perfectly stable so far, now I found a way to crash it:

Thunar (1.0.2-1, binary Arch version) is configured to have tree view in side
pane (View -> Side Pane -> Tree). If I click the arrow to expant "File
System" I can see to content of my root filesystem for a moment, then the
screen gets black and the following error is printed:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [<ffffffff810a0ff1>] cgroup_path+0x21/0xe0
PGD 7b98d067 PUD 7b483067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs
file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0e/PNP0C09:00/PNP0C0A:00/power_supply/BAT1/voltage_now
CPU 1 Modules linked in: usb_storage netconsole configfs tun michael_mic arc4
ecb fuse cpufreq_ondemand rfcomm microcode sco bnep l2cap crc16 ip6t_REJECT
ip6t_LOG nf_conntrack_ipv6 ip6table_mangle ip6table_filter ip6_tables ipv6
xt_pkttype ipt_REDIRECT ipt_MASQUERADE xt_DSCP xt_dscp xt_tcpudp ipt_REJECT
ipt_LOG xt_limit xt_recent xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables
loop snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
vboxnetadp vboxnetflt lib80211_crypt_tkip snd_pcm_oss snd_mixer_oss joydev
battery ac wl(P) vboxdrv i915 thermal snd_hda_codec_realtek btusb bluetooth
rfkill drm_kms_helper lib80211 drm snd_hda_intel snd_hda_codec snd_hwdep sky2
sg snd_pcm snd_timer i2c_algo_bit button snd video soundcore output
snd_page_alloc psmouse acpi_cpufreq i2c_i801 evdev shpchp i2c_core pcspkr
intel_agp freq_table pci_hotplug serio_raw processor mperf dummy ext3 jbd
mbcache sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod
sd_mod ahci uhci_hcd libahci libata ehci_hcd scsi_mod usbcore

Pid: 14239, comm: Thunar Tainted: P            2.6.36-ARCH #1
NF110/NF210/NF310          /NF110/NF210/NF310 RIP: 0010:[<ffffffff810a0ff1>]
[<ffffffff810a0ff1>] cgroup_path+0x21/0xe0 RSP: 0018:ffff88007ababd08
EFLAGS: 00010082 RAX: ffff88007b9a7400 RBX: ffff880078310000 RCX:
0000000000000001 RDX: 0000000000000040 RSI: ffff88007ababda8 RDI:
0000000000000000 RBP: ffff88007ababd28 R08: 0000000000000000 R09:
0000000000000000 R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000000 R13: ffff88007ababda8 R14: 0000000000000000 R15:
ffff88007abaa000 FS:  00007f0a5e794710(0000) GS:ffff880001a80000(0000)
knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000038 CR3: 000000007b1a8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Thunar (pid: 14239, threadinfo ffff88007abaa000, task
ffff88007b946f00) Stack:
 ffff880078310000 ffff880078310000 ffff88007f050100 0000000000000000
<0> ffff88007ababe28 ffffffff8104b0c2 0000000000000000 0000000000000000
<0> 0000000000000000 0000000000000000 ffff88005c739cb0 ffff88007abaa000
Call Trace:
 [<ffffffff8104b0c2>] sched_debug_show+0x7a2/0xd70
 [<ffffffff8114caed>] seq_read+0xdd/0x420
 [<ffffffff8114ca10>] ? seq_read+0x0/0x420
 [<ffffffff81184c2e>] proc_reg_read+0x7e/0xc0
 [<ffffffff8112e6f3>] vfs_read+0xc3/0x180
 [<ffffffff8112e7fc>] sys_read+0x4c/0x80
 [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
Code: ff 0f 0b 0f 1f 80 00 00 00 00 55 48 89 e5 48 83 ec 20 4c 89 64 24 08 4c
89 6c 24 10 49 89 fc 48 89 1c 24 4c 89 74 24 18 49 89 f5 <48> 8b 47 38 48 85
c0 74 09 48 81 ff b0 c5 71 81 75 25 66 41 c7 RIP  [<ffffffff810a0ff1>]
cgroup_path+0x21/0xe0 RSP <ffff88007ababd08> CR2: 0000000000000038
---[ end trace 0a7b41d179fb781e ]---
note: Thunar[14239] exited with preempt_count 2

Any ideas what goes wrong?
-- 
Regards,
Chris
