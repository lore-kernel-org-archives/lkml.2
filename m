Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2FGCv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:51:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2FGCv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:51:26 -0400
Date: Wed, 6 Jun 2012 22:51:17 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk
Subject: vmsplice triggering bug in kfree.
Message-ID: <20120607025117.GA28261@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel BUG at mm/slub.c:3474!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 7 
Modules linked in: ipt_ULOG tun fuse binfmt_misc nfnetlink caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr i2c_i801 e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
Pid: 21252, comm: trinity-child7 Not tainted 3.5.0-rc1+ #74
RIP: 0010:[<ffffffff811945ce>]  [<ffffffff811945ce>] kfree+0x26e/0x270
RSP: 0018:ffff880104065c48  EFLAGS: 00010246
RAX: 0020000000000000 RBX: ffff880104065d18 RCX: 0000000000000000
RDX: ffffffff7fffffff RSI: ffff880104065cf0 RDI: ffff880104065d18
RBP: ffff880104065c78 R08: 00000000fffffff2 R09: 0000000000000000
R10: ffffffff821e2d00 R11: 0000000000000001 R12: 0000000000000ffc
R13: ffffea0004101940 R14: 0000000000000000 R15: ffff880104065d98
FS:  00007f5baafd3740(0000) GS:ffff880148a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000ffc CR3: 0000000107181000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child7 (pid: 21252, threadinfo ffff880104064000, task ffff8801080acd60)
Stack:
 0000000000000010 ffff880104065cf0 0000000000000ffc fffffffffffffff2
 0000000000000000 ffff880104065d98 ffff880104065c98 ffffffff811dc9ef
 0000000000000018 0000000000000161 ffff880104065ec8 ffffffff811dcc4c
Call Trace:
 [<ffffffff811dc9ef>] splice_shrink_spd+0x1f/0x30
 [<ffffffff811dcc4c>] vmsplice_to_pipe+0x24c/0x290
 [<ffffffff811db920>] ? page_cache_pipe_buf_release+0x30/0x30
 [<ffffffff810b1e7e>] ? put_lock_stats.isra.23+0xe/0x40
 [<ffffffff8164dee8>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 [<ffffffff8108cd97>] ? local_clock+0x47/0x60
 [<ffffffff81078daa>] ? __hrtimer_start_range_ns+0x14a/0x530
 [<ffffffff810b1ac8>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff81078daa>] ? __hrtimer_start_range_ns+0x14a/0x530
 [<ffffffff810b1e7e>] ? put_lock_stats.isra.23+0xe/0x40
 [<ffffffff8164dee8>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 [<ffffffff8108cd97>] ? local_clock+0x47/0x60
 [<ffffffff81050e0c>] ? do_setitimer+0x1cc/0x310
 [<ffffffff810b1ac8>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff81086f91>] ? get_parent_ip+0x11/0x50
 [<ffffffff81651919>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff811ad4da>] ? fget_light+0x3ca/0x500
 [<ffffffff811dd90d>] sys_vmsplice+0x9d/0x210
 [<ffffffff81655937>] ? sysret_check+0x1b/0x56
 [<ffffffff81326f3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81655912>] system_call_fastpath+0x16/0x1b
Code: e8 58 ac fb ff e9 a8 fe ff ff 0f 0b 4d 8b 6d 30 e9 fe fd ff ff 4c 89 f1 48 89 da 4c 89 ee 4c 89 e7 e8 91 fd 4a 00 e9 87 fe ff ff <0f> 0b 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 89 fb 48 8b 
RIP  [<ffffffff811945ce>] kfree+0x26e/0x270
 RSP <ffff880104065c48>
---[ end trace 77573bf4cc1dedea ]---


That's...


3473         if (unlikely(!PageSlab(page))) {
3474                 BUG_ON(!PageCompound(page));


