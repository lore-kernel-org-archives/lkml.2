Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2GKT0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab2GKT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:26:07 -0400
Date: Wed, 11 Jul 2012 15:25:58 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jlbec@evilplan.org
Subject: 3.5-rc6 configfs BUG_ON
Message-ID: <20120711192558.GA3393@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jlbec@evilplan.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel BUG at fs/configfs/dir.c:59!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 4 
Modules linked in:
 ebtable_nat
 nf_tproxy_core
 hfsplus
 ppp_synctty
 async_tx
 raid6_pq raid10 shpchp fakephp aer_inject ptp pps_core target_core_file target_core_iblock target_core_pscsi tcm_loop target_core_mod vga16fb sysimgblt fb_sys_fops syscopyarea vgastate output platform_lcd lcd sysfillrect n_r3964 n_gsm nozomi jsm serio_raw altera_ps2 input_polldev sparse_keymap uinput ipt_ULOG fuse tun binfmt_misc nfnetlink caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode usb_debug pcspkr i2c_i801 e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]

Pid: 24175, comm: trinity-main Not tainted 3.5.0-rc6+ #102 
RIP: 0010:[<ffffffff812562fb>]  [<ffffffff812562fb>] configfs_d_iput+0x8b/0xa0
RSP: 0018:ffff88014325be08  EFLAGS: 00010282
RAX: ffffffff81256270 RBX: ffff88014159cb98 RCX: 000000000000c7d0
RDX: ffff880006bacd60 RSI: ffff880045f31540 RDI: ffff88000adf14d0
RBP: ffff88014325be18 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880045f31540
R13: ffff8801238f79d0 R14: 0000000000000001 R15: 00000000053f411b
FS:  00007ff8895fa740(0000) GS:ffff880148400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000038e4e10310 CR3: 0000000140c57000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-main (pid: 24175, threadinfo ffff88014325a000, task ffff880006bacd60)
Stack:
 ffff88000adf14d0 ffff880045f31540 ffff88014325be48 ffffffff811ec74f
 ffff88000adf14d0 ffff8801238f79d0 ffff880045f31540 ffff88000adf1530
 ffff88014325be78 ffffffff811ec8a2 ffff88014325beb8 00000000053f40b0
Call Trace:
 [<ffffffff811ec74f>] d_kill+0xaf/0x120
 [<ffffffff811ec8a2>] dput+0xe2/0x1d0
 [<ffffffff811dfaea>] path_put+0x1a/0x30
 [<ffffffff811d9705>] vfs_fstatat+0x55/0x70
 [<ffffffff811d973e>] vfs_lstat+0x1e/0x20
 [<ffffffff811d99ca>] sys_newlstat+0x1a/0x40
 [<ffffffff81696aed>] system_call_fastpath+0x1a/0x1f
Code: f6 43 40 01 75 eb 48 8b 7b 50 e8 41 4d f6 ff 48 8b 3d c2 bf 7f 01 48 89 de e8 a2 52 f6 ff 4c 89 e7 e8 1a b5 f9 ff 5b 41 5c 5d c3 <0f> 0b be 9c 00 00 00 48 c7 c7 30 a2 9e 81 e8 42 2e e1 ff eb a7 
RIP  [<ffffffff812562fb>] configfs_d_iput+0x8b/0xa0
 RSP <ffff88014325be08>
---[ end trace 65e130035db36f7d ]---

  58         if (sd) {
  59                 BUG_ON(sd->s_dentry != dentry);

