Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1HHAbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 20:31:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53646 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1HHAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:31:22 -0400
MIME-Version: 1.0
Date: Sun, 7 Aug 2011 17:31:21 -0700
Message-ID: <CALjC5hY3_Nge6v2yk2QsJhdvLvibiDrWLMAEQPJw22uQUPsT0A@mail.gmail.com>
Subject: cfq crash on 3.0
From: Bret Towe <magnade@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen the following trace on a server dmesg
what got me to notice was the system had been slowing down I assume
since this crash occurred I'm not sure what to share aside this at
this point so say so if you need something
I think I have probably hit this a few times now as system had slowed
down a couple times and ended up rebooting
itself at some point which i don't understand why it was doing that

using deadline for a while now and haven't seen any issues with that yet
system is a via nano single cpu system

[211433.103129] invalid opcode: 0000 [#1] PREEMPT
[211433.103167] Modules linked in: ocfs2 quota_tree btrfs zlib_deflate
crc32c libcrc32c vfat msdos fat reiserfs ext4 jbd2 crc16 ext2
ip6table_mangle ip6_tables cls_fw sch_sfq sch_htb xt_multiport
ipt_REJECT ipt_MASQUERADE xt_tcpmss xt_TCPMSS ipt_REDIRECT iptable_nat
xt_mark xt_state ipt_LOG xt_recent xt_HL xt_limit xt_DSCP xt_length
xt_string ipt_ULOG xt_tcpudp iptable_mangle iptable_filter ip_tables
x_tables nf_nat_ftp nf_conntrack_ftp nf_nat_irc nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 pppoe pppox iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi fuse ocfs2_dlmfs ocfs2_stack_o2cb
ocfs2_dlm ocfs2_nodemanager ppp_generic slhc ipv6 ext3 jbd mbcache
ocfs2_stack_user dlm configfs ocfs2_stackglue nf_conntrack_irc
nf_conntrack usbhid via_cputemp via_rng rng_core padlock_sha
padlock_aes aes_generic psmouse rtc_cmos evdev xfs dm_mod sd_mod
ata_generic uhci_hcd ehci_hcd pata_via r8169 e1000e ide_pci_generic
usbcore [last unloaded: scsi_wait_scan]
[211433.103660]
[211433.103679] Pid: 4126, comm: tgtd Not tainted 3.0.0-via-generic
#11 To Be Filled By O.E.M. To Be Filled By O.E.M./MVB-VX9GSM
[211433.103735] EIP: 0060:[<c027cff4>] EFLAGS: 00010246 CPU: 0
[211433.103771] EIP is at get_request+0x2c4/0x2e0
[211433.103795] EAX: d7038820 EBX: f5a3fb00 ECX: 00000000 EDX: f6192000
[211433.103823] ESI: 00000000 EDI: 02200000 EBP: f6193bc4 ESP: f6193ba4
[211433.103851]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[211433.103879] Process tgtd (pid: 4126, ti=f6192000 task=f57d51d0
task.ti=f6192000)
[211433.103913] Stack:
[211433.103928]  ec7572c0 00000001 00000001 00000005 d5038820 f5a3fb00
f5a3fb00 00000000
[211433.103979]  f6193c00 c027d02d 00000010 f6193be4 c0287a2c d8c76980
00000000 f6193c14
[211433.104030]  f6193c00 c0279667 c37f4960 c02879d0 00000003 f5a3fb00
00000000 f6193c24
[211433.104082] Call Trace:
[211433.104108]  [<c027d02d>] get_request_wait+0x1d/0x120
[211433.104141]  [<c0287a2c>] ? cfq_merge+0x5c/0x90
[211433.104168]  [<c0279667>] ? elv_merge+0xa7/0xb0
[211433.104195]  [<c02879d0>] ? cfq_get_queue+0x200/0x200
[211433.104223]  [<c027d224>] __make_request+0xf4/0x260
[211433.104271]  [<f896df1f>] ? dm_request+0x9f/0x120 [dm_mod]
[211433.104301]  [<c027c865>] generic_make_request+0xf5/0x470
[211433.104333]  [<c0127fff>] ? T.1008+0x3f/0xb0
[211433.104362]  [<c017e973>] ? zone_watermark_ok+0x23/0x30
[211433.104391]  [<c017d38e>] ? mempool_alloc_slab+0xe/0x10
[211433.104420]  [<c027cc27>] submit_bio+0x47/0xc0
[211433.104448]  [<c01d960b>] ? bio_alloc_bioset+0x3b/0xb0
[211433.104476]  [<c01d4c50>] submit_bh+0xe0/0x120
[211433.104501]  [<c01d51b3>] ll_rw_block+0x83/0x90
[211433.104528]  [<c01d7a8f>] __block_write_begin+0x1cf/0x390
[211433.104558]  [<c01d7eba>] block_write_begin+0x4a/0x80
[211433.104586]  [<c01db1c0>] ? blkdev_get_blocks+0x150/0x150
[211433.104615]  [<c01dabfd>] ? blkdev_write_end+0x4d/0x60
[211433.104642]  [<c01dac3f>] blkdev_write_begin+0x2f/0x40
[211433.104670]  [<c01db1c0>] ? blkdev_get_blocks+0x150/0x150
[211433.104699]  [<c017b49d>] generic_file_buffered_write+0xcd/0x200
[211433.104731]  [<c017ccc0>] __generic_file_aio_write+0x1f0/0x4b0
[211433.104764]  [<c015725d>] ? get_futex_key+0x10d/0x1b0
[211433.104792]  [<c01da597>] blkdev_aio_write+0x37/0x90
[211433.104822]  [<c01af35c>] do_sync_write+0x9c/0xd0
[211433.104852]  [<c01af4c3>] ? rw_verify_area+0x63/0x110
[211433.104880]  [<c01af86a>] vfs_write+0x9a/0x140
[211433.104906]  [<c01b059f>] ? fget_light+0x7f/0xe0
[211433.104933]  [<c01af2c0>] ? do_sync_readv_writev+0xd0/0xd0
[211433.104962]  [<c01af98b>] sys_pwrite64+0x7b/0x90
[211433.104990]  [<c0445750>] sysenter_do_call+0x12/0x26
[211433.105014] Code: ba ab ac 01 00 00 04 e9 7b fe ff ff 8d 76 00 8b
4d 08 89 d8 8b 55 f0 e8 1b c4 ff ff 85 c0 75 af 8b 45 f0 81 48 20 00
00 02 00 e9
[211433.105141]  ff ff ff e8 63 64 1c 00 8d 76 00 e9 e3 fe ff ff 8d 74 26 00
[211433.105215] EIP: [<c027cff4>] get_request+0x2c4/0x2e0 SS:ESP 0068:f6193ba4
[211433.106081] ---[ end trace 896d06b6c74a34f0 ]---
