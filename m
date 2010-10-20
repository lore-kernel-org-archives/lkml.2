Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0JTPuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:50:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57409 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0JTPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GWi293gPr6H21rAzV4ULcFIoc/Y7SWNr/VmfdVM/i81jEqoSefIaxrjWPGjsDoxi3w
         3shErCJ3P8fRP7B+YZLUqDmXqSuu36zIPkT/r/dmG6gKg8BJyq3d2+ggbnyYef30Sa1b
         h9Bcx7HOagrnRPmPyUi31CjtJT/ODyIbGoi7I=
Message-ID: <4CBF0FB7.3000602@gmail.com>
Date: Wed, 20 Oct 2010 17:50:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: ptrace BUG [was: mmotm 2010-10-13-17-13 uploaded]
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
In-Reply-To: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 02:13 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to

Hi, I tried to run a process in gdb and got this BUG:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
IP: [<ffffffff810c5c08>] fetch_bp_busy_slots.clone.1+0x28/0x1c0
PGD 1bacfa067 PUD 13b7f1067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
CPU 1
Modules linked in: dvb_usb_af9015 dvb_usb

Pid: 18934, comm: gdb Not tainted 2.6.36-rc7-mm1_64+ #1286 To be filled
by O.E.M./To Be Filled By O.E.M.
RIP: 0010:[<ffffffff810c5c08>]  [<ffffffff810c5c08>]
fetch_bp_busy_slots.clone.1+0x28/0x1c0
RSP: 0018:ffff8801b71a3ca8  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8801b71a3d18 RCX: 0000000000000000
RDX: ffff8801b71a3fd8 RSI: ffff88013bafc800 RDI: ffff8801b71a3d18
RBP: ffff8801b71a3cf8 R08: ffffffff81039620 R09: ffff88013bafc800
R10: fffe060673f40000 R11: 0000000000000001 R12: ffff88013bafc800
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88013bafc800
FS:  00007f0acb802700(0000) GS:ffff8800af280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000080 CR3: 0000000188f40000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gdb (pid: 18934, threadinfo ffff8801b71a2000, task ffff88019ddfee80)
Stack:
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
<0> 0000000000000000 ffff88013bafc800 ffff88013bafc800 0000000000000000
<0> 0000000000000000 ffff88013bafc800 ffff8801b71a3d38 ffffffff810c5dfa
Call Trace:
 [<ffffffff810c5dfa>] __reserve_bp_slot+0x5a/0x90
 [<ffffffff815c26d9>] ? mutex_lock+0x19/0x50
 [<ffffffff810c5e60>] reserve_bp_slot+0x20/0x40
 [<ffffffff810c5f41>] register_perf_hw_breakpoint+0x11/0x50
 [<ffffffff810c8da2>] ? filemap_fault+0x122/0x4b0
 [<ffffffff810c5fad>] hw_breakpoint_event_init+0x2d/0x50
 [<ffffffff810c4346>] perf_init_event+0x36/0x80
 [<ffffffff810c45d8>] perf_event_alloc+0x248/0x350
 [<ffffffff81039620>] ? ptrace_triggered+0x0/0x40
 [<ffffffff810c49bc>] perf_event_create_kernel_counter+0x2c/0x150
 [<ffffffff810c5601>] register_user_hw_breakpoint+0x11/0x20
 [<ffffffff8103975e>] ptrace_set_breakpoint_addr+0xde/0x100
 [<ffffffff8103a485>] ptrace_set_debugreg+0x55/0x80
 [<ffffffff8103a902>] arch_ptrace+0xe2/0x370
 [<ffffffff81074c18>] sys_ptrace+0x68/0xc0
 [<ffffffff815c3e1f>] ? page_fault+0x1f/0x30
 [<ffffffff8102ee2b>] system_call_fastpath+0x16/0x1b
Code: 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 f4 53 48 89 fb
48 83 ec 28 44 8b b6 dc 01 00 00 48 8b 86 80 01 00 00 45 85 f6 <4c> 8b
a8 80 00 00 00 78 5f 48 c7 c0 d8 e2 00 00 4d 63 f6 4a 8b
RIP  [<ffffffff810c5c08>] fetch_bp_busy_slots.clone.1+0x28/0x1c0
 RSP <ffff8801b71a3ca8>
CR2: 0000000000000080
---[ end trace 8199f8c45e224e74 ]---
psi[18938] trap int3 ip:7ffff3bdaa01 sp:7fffffffccc8 error:0

Is there a pacth for this already? Or should I investigate further?

regards,
-- 
js
