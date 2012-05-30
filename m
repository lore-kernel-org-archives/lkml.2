Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2E3F1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:27:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2E3F1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:27:22 -0400
Date: Wed, 30 May 2012 01:27:17 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: vma_resv_map bug.
Message-ID: <20120530052716.GA12771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since c50ac050811d6485616a193eb0f37bfbd191cc89, I can trigger this fairly easily
using my syscall fuzzer.

	Dave

BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff81182959>] vma_resv_map+0x9/0x30
PGD 141453067 PUD 1421e1067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
CPU 6 
Modules linked in: binfmt_misc caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode serio_raw pcspkr i2c_i801 lpc_ich mfd_core e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]

Pid: 14006, comm: trinity-child6 Not tainted 3.4.0+ #36
RIP: 0010:[<ffffffff81182959>]  [<ffffffff81182959>] vma_resv_map+0x9/0x30
RSP: 0018:ffff8801414e1d48  EFLAGS: 00010246
RAX: 00000000fffffff4 RBX: 0000000000000000 RCX: 000000000000b990
RDX: 00000000fffffff4 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8801414e1d48 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000002 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: ffff88013febf0d0
FS:  00007fc3866f5740(0000) GS:ffff880148800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000030 CR3: 00000001437b1000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child6 (pid: 14006, threadinfo ffff8801414e0000, task ffff8801414f26b0)
Stack:
 ffff8801414e1d58 ffffffff81182cde ffff8801414e1db8 ffffffff81185fe6
 0000000000008000 00000000fffffff4 ffffffff82a24ce0 0000000000000000
 ffff8801414e1db8 ffff88013febf0d0 0000000000000001 ffff880137b05c20
Call Trace:
 [<ffffffff81182cde>] resv_map_put+0xe/0x40
 [<ffffffff81185fe6>] hugetlb_reserve_pages+0xa6/0x1d0
 [<ffffffff8128c312>] hugetlb_file_setup+0x102/0x2c0
 [<ffffffff812a1a25>] newseg+0x115/0x360
 [<ffffffff8129bcfe>] ipcget+0x1ce/0x310
 [<ffffffff812a1e6a>] sys_shmget+0x5a/0x60
 [<ffffffff812a1910>] ? shmctl_down.constprop.14+0x180/0x180
 [<ffffffff812a0f90>] ? shm_release+0x50/0x50
 [<ffffffff812a0f20>] ? shm_get_unmapped_area+0x20/0x20
 [<ffffffff816613d2>] system_call_fastpath+0x16/0x1b
Code: 40 30 48 8b 40 28 48 8b 80 b0 05 00 00 48 8b 40 58 8b 48 08 b8 01 00 00 00 83 c1 0c 48 d3 e0 c3 66 90 55 48 89 e5 66 66 66 66 90 <48> 8b 47 30 a9 00 00 40 00 74 18 a8 80 75 10 48 8b 87 a0 00 00 

