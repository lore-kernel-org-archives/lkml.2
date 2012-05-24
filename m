Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab2EXQBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:01:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab2EXQBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:01:52 -0400
Date: Thu, 24 May 2012 12:01:46 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: tracing ring_buffer_resize oops.
Message-ID: <20120524160146.GA6226@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit this while trying to configure the irq-tracer.
I ran cat trace before doing a "echo 0 > tracing_on" by mistake.
Shot myself in the foot, but it still shouldn't oops.

	Dave


BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
IP: [<ffffffff8110b72d>] ring_buffer_resize+0xad/0x430
PGD 141eaf067 PUD 13f6d3067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
CPU 6 
Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel usb_debug ghash_clmulni_intel microcode serio_raw pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]

Pid: 731, comm: bash Not tainted 3.4.0+ #29 
RIP: 0010:[<ffffffff8110b72d>]  [<ffffffff8110b72d>] ring_buffer_resize+0xad/0x430
RSP: 0018:ffff88013f83bdb8  EFLAGS: 00010217
RAX: ffff880145d60390 RBX: 00000000001609e0 RCX: 0000000000000006
RDX: 0000000000000008 RSI: ffffffff8110b714 RDI: ffffffff8165790a
RBP: ffff88013f83bdf8 R08: 2222222222222222 R09: 2222222222222222
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801462f0920
R13: 0000000000000162 R14: 0000000000000008 R15: 0000000000000000
FS:  00007fd389ddb740(0000) GS:ffff880148800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000064 CR3: 000000013e66d000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 731, threadinfo ffff88013f83a000, task ffff880140220000)
Stack:
 ffff8801462f0940 ffff8801417c4310 ffff8801417c4310 0000000000000008
 000000000000000c 00000000001609e0 ffff8801417c4310 ffffffff81c7b2f0
 ffff88013f83be48 ffffffff81114451 ffffffff81d34880 ffffffff81c7b260
Call Trace:
 [<ffffffff81114451>] tracing_set_tracer+0x221/0x320
 [<ffffffff81114615>] tracing_set_trace_write+0xc5/0x100
 [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
 [<ffffffff812ad55c>] ? security_file_permission+0x2c/0xb0
 [<ffffffff811a725f>] vfs_write+0xaf/0x190
 [<ffffffff811a759d>] sys_write+0x4d/0x90
 [<ffffffff81662912>] system_call_fastpath+0x16/0x1b
Code: 8d 44 24 20 31 f6 48 89 c7 48 89 45 c0 e8 3c bf 54 00 41 83 fe ff 0f 84 05 01 00 00 49 8b 84 24 c8 00 00 00 49 63 d6 4c 8b 3c d0 <41> 8b 47 64 44 39 e8 74 7a 44 89 ef 49 8d b7 f8 00 00 00 29 c7 

