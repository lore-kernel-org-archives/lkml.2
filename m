Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2EVBj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab2EVBj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:39:56 -0400
Date: Mon, 21 May 2012 21:39:50 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4+ dcache BUG.
Message-ID: <20120522013949.GA31883@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120522011152.GA18115@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522011152.GA18115@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 09:11:52PM -0400, Dave Jones wrote:
 > Just hit this. Probably related to todays dcache changes ?
 > 
 > kernel BUG at fs/dcache.c:229!
 > invalid opcode: 0000 [#1] PREEMPT SMP 
 > CPU 2 
 > Modules linked in: ipt_ULOG nfnetlink x25 phonet llc2 can rose af_key caif_socket caif netrom rds binfmt_misc bluetooth rfkill pppoe pppox ppp_generic slhc decnet ipx p8023 p8022 irda crc_ccitt atm appletalk psnap llc ax25 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw i2c_i801 usb_debug e1000e iTCO_wdt iTCO_vendor_support nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
 > 
 > Pid: 15394, comm: cc1 Not tainted 3.4.0+ #17 

Rebuilt a fresh kernel. This time I got this instead..


kernel BUG at fs/namei.c:516!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 5 
Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel serio_raw ghash_clmulni_intel microcode pcspkr usb_debug i2c_i801 iTCO_wdt iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]

Pid: 2822, comm: sh Not tainted 3.4.0+ #19
RIP: 0010:[<ffffffff811b22d4>]  [<ffffffff811b22d4>] complete_walk+0x174/0x180
RSP: 0018:ffff88002b459d08  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88002b459e48 RCX: 0000000000000004
RDX: 0000000000000007 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff88002b459d38 R08: 0000000000000001 R09: 0000000000000001
R10: ffff88013e46a6a0 R11: ffff88013e46aff0 R12: ffff88000a3e4de0
R13: ffff88000a3e4e40 R14: ffff880112f3b480 R15: ffff88010430bd70
FS:  00007fced19e8740(0000) GS:ffff880148600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003768278630 CR3: 00000000090b1000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 2822, threadinfo ffff88002b458000, task ffff88013e46a6a0)
Stack:
 0000000000000040 ffff88002b459e48 0000000000088000 ffff88002b459e48
 0000000000088000 0000000000000024 ffff88002b459da8 ffffffff811b4a98
 ffff8801462bd1a0 ffff880100000001 ffff88002b459de8 ffff880112f3b486
Call Trace:
 [<ffffffff811b4a98>] do_last+0x138/0x900
 [<ffffffff811b5372>] path_openat+0xd2/0x3f0
 [<ffffffff81009e86>] ? native_sched_clock+0x26/0x90
 [<ffffffff811c3f51>] ? alloc_fd+0x171/0x220
 [<ffffffff811b57b1>] do_filp_open+0x41/0xa0
 [<ffffffff81653595>] ? _raw_spin_unlock+0x35/0x60
 [<ffffffff811c3f51>] ? alloc_fd+0x171/0x220
 [<ffffffff811a315d>] do_sys_open+0xed/0x1c0
 [<ffffffff811a3251>] sys_open+0x21/0x30
 [<ffffffff8165ae52>] system_call_fastpath+0x16/0x1b
Code: ff ff 8b 45 d8 e9 7e ff ff ff e8 2b 7d 49 00 4c 89 ef e8 a0 12 4a 00 e8 9b e3 ff ff e8 66 26 01 00 b8 f6 ff ff ff e9 5d ff ff ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 41 54 53 
RIP  [<ffffffff811b22d4>] complete_walk+0x174/0x180

That's...

	BUG_ON(nd->inode != dentry->d_inode);



followed by a slew of CPU stuck for 22s! traces.

	Dave
