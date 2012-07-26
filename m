Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GZLn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:43:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab2GZLn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:43:27 -0400
Message-ID: <50112D3B.4020201@redhat.com>
Date: Thu, 26 Jul 2012 14:42:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com>
In-Reply-To: <500ED719.2010002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 08:10 PM, Sasha Levin wrote:
> [  215.026612] NMI backtrace for cpu 1
> [  215.026612] CPU 1
> [  215.026612] Pid: 2395, comm: pageattr-test Tainted: G        W    3.5.0-sasha-01644-g824681b #267
> [  215.026612] RIP: 0010:[<ffffffff8109bd5a>]  [<ffffffff8109bd5a>] native_write_msr_safe+0xa/0x10
> [  215.026612] RSP: 0018:ffff88001b803f70  EFLAGS: 00000046
> [  215.026612] RAX: 0000000000000000 RBX: 000000000000ef80 RCX: 000000000000080b
> [  215.026612] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000080b
> [  215.026612] RBP: ffff88001b803f70 R08: 00003ffffffff000 R09: ffff880000000000
> [  215.026612] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [  215.026612] R13: ffff880007a98000 R14: ffff88001fc3a4b8 R15: ffff880000000000
> [  215.026612] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
> [  215.026612] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  215.026612] CR2: 000000000000000c CR3: 0000000019dcf000 CR4: 00000000000406e0
> [  215.026612] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  215.026612] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  215.026612] Process pageattr-test (pid: 2395, threadinfo ffff88000ced0000, task ffff88000d773000)
> [  215.026612] Stack:
> [  215.026612]  ffff88001b803f88 ffffffff81095d07 000000000000ef80 ffff88001b803fa8
> [  215.026612]  ffffffff810901c4 ffff88000ced1db0 0000000000007a98 ffff88000ced1d00
> [  215.026612]  ffffffff8369c4af ffff88000ced1c78 <EOI>  ffff88000ced1d00 ffffffff8369aeb4
> [  215.026612] Call Trace:
> [  215.026612]  <IRQ>
> [  215.026612]  [<ffffffff81095d07>] native_apic_msr_eoi_write+0x27/0x30
> [  215.026612]  [<ffffffff810901c4>] smp_apic_timer_interrupt+0x34/0xa0
> [  215.026612]  [<ffffffff8369c4af>] apic_timer_interrupt+0x6f/0x80
> [  215.026612]  <EOI>
> [  215.026612]  [<ffffffff8369aeb4>] ? retint_restore_args+0x13/0x13
> [  215.026612]  [<ffffffff810a2cb2>] ? lookup_address+0x112/0x170
> [  215.026612]  [<ffffffff810a32ae>] print_split+0x7e/0x200
> [  215.026612]  [<ffffffff810a4300>] pageattr_test+0x80/0x4a0
> [  215.026612]  [<ffffffff8114a2f8>] ? trace_hardirqs_on_caller+0x118/0x140
> [  215.026612]  [<ffffffff83696cbe>] ? schedule_timeout+0x2ce/0x370
> [  215.026612]  [<ffffffff8369aeb4>] ? retint_restore_args+0x13/0x13
> [  215.026612]  [<ffffffff810a4720>] ? pageattr_test+0x4a0/0x4a0
> [  215.026612]  [<ffffffff810a473f>] do_pageattr_test+0x1f/0x50
> [  215.026612]  [<ffffffff8110607d>] kthread+0xad/0xc0
> [  215.026612]  [<ffffffff8369cdb4>] kernel_thread_helper+0x4/0x10
> [  215.026612]  [<ffffffff8369aeb4>] ? retint_restore_args+0x13/0x13
> [  215.026612]  [<ffffffff81105fd0>] ? kthread_flush_work_fn+0x10/0x10
> [  215.026612]  [<ffffffff8369cdb0>] ? gs_change+0x13/0x13
> [  215.026612] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 48 89 d0 44 89 06 48 c1 e0 20 89 f9 5d 48 09 c8 c3 66 90 55 89 f0 89 f9 48 89 e5 0f 30 <31> c0 5d c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 48 89 d0 5d 48

This is immediately after the EOI.  It looks like the timer interrupt is
stuck somehow.  Can you run kvm_stat and confirm?


-- 
error compiling committee.c: too many arguments to function


