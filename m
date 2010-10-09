Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab0JILbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 07:31:08 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:41533 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0JILbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 07:31:06 -0400
Message-ID: <4CB05276.70705@xs4all.nl>
Date: Sat, 09 Oct 2010 13:31:02 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bug in 2.6.35.2
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was just typing and this happened:

Oct  9 13:11:17 doos kernel: BUG: unable to handle kernel NULL pointer
dereference at (null)
Oct  9 13:11:17 doos kernel: IP: [<ffffffff81162475>]
ext4_mb_good_group+0x55/0x120
Oct  9 13:11:17 doos kernel: PGD 2e703067 PUD b7ca8067 PMD 0
Oct  9 13:11:17 doos kernel: Oops: 0000 [#1] PREEMPT SMP
Oct  9 13:11:17 doos kernel: last sysfs file:
/sys/devices/virtual/net/vboxnet0/statistics/collisions
Oct  9 13:11:17 doos kernel: CPU 0
Oct  9 13:11:17 doos kernel: Modules linked in: vfat fat eeprom i2c_dev
i2c_piix4 vboxnetadp vboxnetflt vboxdrv nls_utf8 nfs usb_storage isofs
sit tunnel4 radeon ttm drm_kms_helper drm fb fbdev i2c_algo_bit
cfbcopyarea cfbimgblt cfbfillrect rfcomm sco bridge stp llc bnep l2cap
nfsd nfs_acl auth_rpcgss exportfs it87 hwmon_vid lockd sunrpc
powernow_k8 mperf ipt_REJECT iptable_filter ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
nf_conntrack_netbios_ns ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables x_tables binfmt_misc dm_mirror
dm_region_hash dm_log snd_hda_codec_atihdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec ppdev snd_seq snd_seq_device parport_pc
parport snd_pcm pwc videodev usblp sg v4l1_compat k10temp ohci1394
ieee1394 v4l2_compat_ioctl32 btusb snd_timer snd evdev bluetooth button
snd_page_alloc sr_mod cdrom ide_pci_generic atiixp pata_atiixp ehci_hcd
ohci_hcd sata_sil24 floppy [last unloaded: eeprom]
Oct  9 13:11:17 doos kernel:
Oct  9 13:11:17 doos kernel: Pid: 20976, comm: flush-253:4 Not tainted
2.6.35.2 #2 GA-MA770-DS3/
Oct  9 13:11:17 doos kernel: RIP: 0010:[<ffffffff81162475>]
[<ffffffff81162475>] ext4_mb_good_group+0x55/0x120
Oct  9 13:11:17 doos kernel: RSP: 0018:ffff8800b7cb3790  EFLAGS: 00010293
Oct  9 13:11:17 doos kernel: RAX: 0000000000000000 RBX: ffff880036b6df40
RCX: 0000000000000000
Oct  9 13:11:17 doos kernel: RDX: 0000000000000000 RSI: ffff88012dc54000
RDI: ffff88012f40d800
Oct  9 13:11:17 doos kernel: RBP: 0000000000001300 R08: 0000000000000026
R09: ffff88012e7cb0e0
Oct  9 13:11:17 doos kernel: R10: 000000000000000b R11: dead000000200200
R12: 0000000000000000
Oct  9 13:11:17 doos kernel: R13: ffff8800b7cb3800 R14: 0000000000001300
R15: 000000000000004f
Oct  9 13:11:17 doos kernel: FS:  00007f57b23e3740(0000)
GS:ffff880001800000(0000) knlGS:00000000f7790860
Oct  9 13:11:17 doos kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Oct  9 13:11:17 doos kernel: CR2: 0000000000000000 CR3: 000000002fcbd000
CR4: 00000000000006f0
Oct  9 13:11:17 doos kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Oct  9 13:11:17 doos kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Oct  9 13:11:17 doos kernel: Process flush-253:4 (pid: 20976, threadinfo
ffff8800b7cb2000, task ffff88012ff82c70)
Oct  9 13:11:17 doos kernel: Stack:
Oct  9 13:11:17 doos kernel: 0000000000000000 ffffffff81034319
0000000000000001 ffff880036b6df40
Oct  9 13:11:17 doos kernel: <0> 0000000000000000 0000000000001200
ffff8800b7cb3800 ffffffff81163128
Oct  9 13:11:17 doos kernel: <0> ffff88012e076ec0 ffff88012f40d800
ffffe8ffffc08d80 ffff88012e00ead8
Oct  9 13:11:17 doos kernel: Call Trace:
Oct  9 13:11:17 doos kernel: [<ffffffff81034319>] ? get_parent_ip+0x9/0x20
Oct  9 13:11:17 doos kernel: [<ffffffff81163128>] ?
ext4_mb_regular_allocator+0x178/0x3d0
Oct  9 13:11:17 doos kernel: [<ffffffff81035bcf>] ?
sub_preempt_count+0x7f/0xb0
Oct  9 13:11:17 doos kernel: [<ffffffff8115ef98>] ?
ext4_mb_normalize_request+0x298/0x4c0
Oct  9 13:11:17 doos kernel: [<ffffffff81163643>] ?
ext4_mb_new_blocks+0x2c3/0x3a0
Oct  9 13:11:17 doos kernel: [<ffffffff810e63f6>] ?
__find_get_block_slow+0xa6/0x120
Oct  9 13:11:17 doos kernel: [<ffffffff811434f7>] ?
ext4_alloc_branch+0x477/0x570
Oct  9 13:11:17 doos kernel: [<ffffffff811413d3>] ?
ext4_get_branch+0x113/0x140
Oct  9 13:11:17 doos kernel: [<ffffffff811437d4>] ?
ext4_ind_map_blocks+0x1e4/0x610
Oct  9 13:11:17 doos kernel: [<ffffffff81035bcf>] ?
sub_preempt_count+0x7f/0xb0
Oct  9 13:11:17 doos kernel: [<ffffffff81143ebf>] ?
ext4_map_blocks+0xdf/0x200
Oct  9 13:11:17 doos kernel: [<ffffffff81144a28>] ?
mpage_da_map_blocks+0xb8/0x460
Oct  9 13:11:17 doos kernel: [<ffffffff81153178>] ?
ext4_journal_start_sb+0xf8/0x130
Oct  9 13:11:17 doos kernel: [<ffffffff8114554c>] ?
ext4_da_writepages+0x2cc/0x510
Oct  9 13:11:17 doos kernel: [<ffffffff81055c34>] ? bit_waitqueue+0x14/0xc0
Oct  9 13:11:17 doos kernel: [<ffffffff810df764>] ?
writeback_single_inode+0xd4/0x3c0
Oct  9 13:11:17 doos kernel: [<ffffffff810dfee4>] ?
writeback_sb_inodes+0x194/0x280
Oct  9 13:11:17 doos kernel: [<ffffffff810e0873>] ?
writeback_inodes_wb+0x63/0x180
Oct  9 13:11:17 doos kernel: [<ffffffff810e0bb3>] ? wb_writeback+0x223/0x280
Oct  9 13:11:17 doos kernel: [<ffffffff813a7f8e>] ?
_raw_spin_lock_irqsave+0x1e/0x50
Oct  9 13:11:17 doos kernel: [<ffffffff8104a01c>] ?
try_to_del_timer_sync+0x6c/0x90
Oct  9 13:11:17 doos kernel: [<ffffffff810e0db6>] ?
wb_do_writeback+0x1a6/0x1b0
Oct  9 13:11:17 doos kernel: [<ffffffff810e0e0b>] ?
bdi_writeback_task+0x4b/0x130
Oct  9 13:11:17 doos kernel: [<ffffffff81055c34>] ? bit_waitqueue+0x14/0xc0
Oct  9 13:11:17 doos kernel: [<ffffffff810a1ce0>] ? bdi_start_fn+0x0/0xf0
Oct  9 13:11:17 doos kernel: [<ffffffff810a1d5e>] ? bdi_start_fn+0x7e/0xf0
Oct  9 13:11:17 doos kernel: [<ffffffff810a1ce0>] ? bdi_start_fn+0x0/0xf0
Oct  9 13:11:17 doos kernel: [<ffffffff810558ae>] ? kthread+0x8e/0xa0
Oct  9 13:11:17 doos kernel: [<ffffffff81003194>] ?
kernel_thread_helper+0x4/0x10
Oct  9 13:11:17 doos kernel: [<ffffffff81055820>] ? kthread+0x0/0xa0
Oct  9 13:11:17 doos kernel: [<ffffffff81003190>] ?
kernel_thread_helper+0x0/0x10
Oct  9 13:11:17 doos kernel: Code: 00 8b 88 90 00 00 00 48 8b b0 30 02
00 00 44 8b a0 00 03 00 00 41 d3 e8 48 8b 48 30 45 89 c0 4a 8b 04 c6 48
ff c9 21 e9 83 fa 03 <4c> 8b 2c c8 0f 87 b1 00 00 00 41 f6 45 00 01 75
57 41 8b 45 14
Oct  9 13:11:17 doos kernel: RIP  [<ffffffff81162475>]
ext4_mb_good_group+0x55/0x120
Oct  9 13:11:17 doos kernel: RSP <ffff8800b7cb3790>
Oct  9 13:11:17 doos kernel: CR2: 0000000000000000
Oct  9 13:11:17 doos kernel: ---[ end trace 7ba0e2e548db085e ]---
Oct  9 13:12:36 doos abrt: Kerneloops: Reported 1 kernel oopses to Abrt


Any idea?


Udo
