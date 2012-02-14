Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2BNQoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:44:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:55618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2BNQoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:44:18 -0500
Message-ID: <1329237838.2293.20.camel@twins>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Date: Tue, 14 Feb 2012 17:43:58 +0100
In-Reply-To: <1329236924.2293.13.camel@twins>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1329236924.2293.13.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 17:28 +0100, Peter Zijlstra wrote:
> 
> I added the below but all I managed was to crash my kernel, its probably
> a simple thing, but sysfs didn't give a hint.

This isn't it either..

crash looks like:

general protection fault: 0000 [#1] PREEMPT SMP 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper/0 Not tainted 3.3.0-rc3-01426-g2ce21a5-dirty #78 Supermicro X8DTN/X8DTN
RIP: 0010:[<ffffffff812e258e>]  [<ffffffff812e258e>] strcmp+0x4/0x21
RSP: 0018:ffff880236879c90  EFLAGS: 00010286
RAX: ffff880235ac7660 RBX: 0000000000000000 RCX: ffff880236870000
RDX: 0000000000000000 RSI: ffffffff81b295a6 RDI: 6e7500746e657665
RBP: ffff880236879c90 R08: 0000000000000180 R09: 6e7500746e657665
R10: ffffffff812ddedd R11: ffff880236879dc0 R12: 0000000000000000
R13: ffff880235ac7630 R14: 6e7500746e657665 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff880237c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001c05000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff880236878000, task ffff880236870000)
Stack:
 ffff880236879cc0 ffffffff811996e2 ffff880235ac7ab0 ffff880236879d30
 ffff880236879d30 ffff880235ac7ab0 ffff880236879ce0 ffffffff81199957
 ffff880236879d30 ffff880235ac75a0 ffff880236879d10 ffffffff81199a06
Call Trace:
 [<ffffffff811996e2>] sysfs_find_dirent+0x79/0xda
 [<ffffffff81199957>] __sysfs_add_one+0x73/0xc3
 [<ffffffff81199a06>] sysfs_add_one+0x1b/0xab
 [<ffffffff81198fa8>] sysfs_add_file_mode+0x7e/0xb7
 [<ffffffff8119b841>] internal_create_group+0xed/0x168
 [<ffffffff8119b8e7>] sysfs_create_group+0x13/0x18
 [<ffffffff814861fc>] device_add_groups+0x2a/0x69
 [<ffffffff81198ff3>] ? sysfs_add_file+0x12/0x14
 [<ffffffff81486f8f>] device_add+0x37f/0x636
 [<ffffffff8148672b>] ? kzalloc.clone.0+0xe/0x10
 [<ffffffff810f069a>] pmu_dev_alloc+0x88/0xa4
 [<ffffffff81d11114>] ? init_kprobe_trace+0x90/0x90
 [<ffffffff81d1115f>] perf_event_sysfs_init+0x4b/0x9a
 [<ffffffff81d11114>] ? init_kprobe_trace+0x90/0x90
 [<ffffffff8100020f>] do_one_initcall+0x7f/0x139
 [<ffffffff81cf65ba>] kernel_init+0xa2/0x122
 [<ffffffff8109083e>] ? schedule_tail+0x31/0x74
 [<ffffffff817af2a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81cf6518>] ? parse_early_options+0x20/0x20
 [<ffffffff817af2a0>] ? gs_change+0x13/0x13
Code: 48 ff c1 80 39 00 75 f8 eb 0d 48 ff c1 48 ff ca 75 05 c6 01 00 eb
0e 40 8a 3e 48 ff c6 40 88 39 40 84 ff 75 e5 c9 c3 55 48 89 e5 <8a> 07
8a 16 48 ff c7 48 ff c6 38 d0 74 07 19 c0 83 c8 01 eb 06 
RIP  [<ffffffff812e258e>] strcmp+0x4/0x21
 RSP <ffff880236879c90>
---[ end trace 5283cffd22793f50 ]---


And yes, I already send greg a patch for that sillyness in
sysfs_find_dirent.

---
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1605,6 +1605,7 @@ static struct attribute *x86_pmu_attrs[]
 };
 
 static struct attribute_group x86_pmu_attr_group = {
+	.name = "attributes",
 	.attrs = x86_pmu_attrs,
 };
 

