Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1JDMDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:03:25 -0400
Received: from websrv.saout.de ([78.46.99.52]:45795 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab1JDMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:03:23 -0400
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 14:02:41 +0200
Message-ID: <1317729761.25998.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> Anyway, it would help a great deal if you could retrigger the failure
> and provide the full failure output.  You can get that by issuing the
> 'dmesg' command and redirecting it to a file.

Oh, sorry, yes, there's a line missing.

Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);

The bug is not specific to GFS2, I also get it when using an ext3 mount
on that multipath storage pool when writing to a file.

Thanks,
	Christophe

------------[ cut here ]------------
kernel BUG at block/blk-flush.c:323!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 18 
Modules linked in: gfs2 fuse dlm configfs dummy bonding xt_TPROXY
nf_tproxy_core xt_socket xt_owner xt_connmark iptable_mangle
ipt_MASQUERADE iptable_nat ipt_ULOG ipt_REJECT xt_mark iptable_filter
iptable_raw ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
xt_state xt_tcpudp xt_physdev xt_hashlimit xt_multiport ip6table_filter
ip6_tables ebt_redirect ebt_ip ebt_mark_m ebtable_broute bridge stp llc
ebtable_nat ext4 jbd2 dm_round_robin dm_multipath ebtable_filter
ebtables x_tables nf_nat_tftp nf_conntrack_tftp nf_nat_sip
nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_h323
nf_conntrack_h323 nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_conntrack_ftp nf_conntrack ipmi_si ipmi_devintf ipmi_msghandler loop
e1000e qla2xxx igb pata_atiixp ohci_hcd ehci_hcd tpm_tis tpm
scsi_transport_fc tpm_bios i2c_piix4

Pid: 5282, comm: umount Not tainted 3.1.0-rc3 #1 Supermicro
H8DG6/H8DGi/H8DG6/H8DGi
RIP: 0010:[<ffffffff8121a2e4>]  [<ffffffff8121a2e4>] blk_insert_flush
+0x134/0x140
RSP: 0018:ffff8808155f3988  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880c149f0018 RCX: ffff881014170000
RDX: 0000000000000005 RSI: 0000000000000001 RDI: ffff880c149f0018
RBP: ffff8808155f3988 R08: 0000000000000001 R09: 0000000000000001
R10: ffff880415cf0440 R11: 0000000000000000 R12: ffff881014170000
R13: 0000000000000082 R14: 0000000000000005 R15: ffff880c13763044
FS:  00007f2d80611740(0000) GS:ffff880c17c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f2d7fd4c0b0 CR3: 0000000c0fa3e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 5282, threadinfo ffff8808155f2000, task
ffff8808155ed320)
Stack:
 ffff8808155f39b8 ffffffff812110a2 ffff880c149f0018 ffff881014170000
 0000000000000082 ffff880c13763000 ffff8808155f39e8 ffffffff81215bd4
 ffff8808155f39e8 ffff880c00000005 ffff880c149f0018 ffff881014170000
Call Trace:
 [<ffffffff812110a2>] __elv_add_request+0x172/0x240
 [<ffffffff81215bd4>] add_acct_request+0x34/0x40
 [<ffffffff81215c4b>] blk_insert_cloned_request+0x6b/0x90
 [<ffffffff8138ec39>] dm_dispatch_request+0x39/0x70
 [<ffffffff8139011b>] dm_request_fn+0x1ab/0x2b0
 [<ffffffff81211a56>] __blk_run_queue+0x16/0x20
 [<ffffffff812182ed>] __make_request+0x2ed/0x330
 [<ffffffff8138fd3e>] dm_request+0x16e/0x1e0
 [<ffffffff81216077>] generic_make_request+0x2d7/0x520
 [<ffffffff8104be91>] ? get_parent_ip+0x11/0x50
 [<ffffffff81216321>] submit_bio+0x61/0xd0
 [<ffffffff81146c86>] submit_bh+0xe6/0x120
 [<ffffffffa034c338>] log_write_header+0x208/0x4b0 [gfs2]
 [<ffffffff814c85c5>] ? sub_preempt_count+0x95/0xd0
 [<ffffffffa034c698>] gfs2_log_shutdown+0xb8/0x280 [gfs2]
 [<ffffffffa0362908>] gfs2_make_fs_ro+0x78/0xc0 [gfs2]
 [<ffffffffa03628e9>] ? gfs2_make_fs_ro+0x59/0xc0 [gfs2]
 [<ffffffffa0362b38>] gfs2_put_super+0x1e8/0x210 [gfs2]
 [<ffffffff8111c64d>] generic_shutdown_super+0x5d/0xe0
 [<ffffffff8111c6fc>] kill_block_super+0x2c/0x80
 [<ffffffffa035465c>] gfs2_kill_sb+0x5c/0x90 [gfs2]
 [<ffffffff8111ca08>] deactivate_locked_super+0x38/0x90
 [<ffffffff8111d4e5>] deactivate_super+0x45/0x60
 [<ffffffff81137a77>] mntput_no_expire+0xe7/0x130
 [<ffffffff81138489>] sys_umount+0x79/0x390
 [<ffffffff814cbed2>] system_call_fastpath+0x16/0x1b
Code: d2 e8 51 c7 ff ff c9 c3 0f 1f 80 00 00 00 00 48 8b 41 08 48 89 79
08 48 89 0f 48 89 47 08 48 89 38 48 89 cf e8 3e d9 ff ff c9 c3 <0f> 0b
eb fe 0f 1f 84 00 00 00 00 00 55 89 f2 be 02 00 00 00 48 
RIP  [<ffffffff8121a2e4>] blk_insert_flush+0x134/0x140
 RSP <ffff8808155f3988>
---[ end trace d37a65fe4ba84f7e ]---
note: umount[5282] exited with preempt_count 1



