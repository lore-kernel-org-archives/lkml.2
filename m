Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0GLTRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:17:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0GLTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:17:48 -0400
Date: Mon, 12 Jul 2010 14:54:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: PIT: stop vpit before irq_routing freed
Message-ID: <20100712175437.GA8193@amt.cnet>
References: <4C383F74.4040606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C383F74.4040606@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 05:37:56PM +0800, Xiao Guangrong wrote:
> Fix:
> general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> ......
> Call Trace:
>  [<ffffffffa0159bd1>] ? kvm_set_irq+0xdd/0x24b [kvm]
>  [<ffffffff8106ea8b>] ? trace_hardirqs_off_caller+0x1f/0x10e
>  [<ffffffff813ad17f>] ? sub_preempt_count+0xe/0xb6
>  [<ffffffff8106d273>] ? put_lock_stats+0xe/0x27
>  [<ffffffff8106e94b>] ? lock_release_holdtime+0x104/0x109
>  [<ffffffff813ad214>] ? sub_preempt_count+0xa3/0xb6
>  [<ffffffffa017cdae>] pit_do_work+0x69/0xc8 [kvm]
>  [<ffffffff8105a441>] worker_thread+0x28e/0x3b0
>  [<ffffffff8105a3e5>] ? worker_thread+0x232/0x3b0
>  [<ffffffffa017cd45>] ? pit_do_work+0x0/0xc8 [kvm]
>  [<ffffffff8105eafe>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff8105a1b3>] ? worker_thread+0x0/0x3b0
>  [<ffffffff8105e571>] kthread+0x7f/0x87
>  [<ffffffff810039d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81036370>] ? finish_task_switch+0x70/0xe4
>  [<ffffffff813a9e89>] ? _raw_spin_unlock_irq+0x3b/0x58
>  [<ffffffff813aa400>] ? restore_args+0x0/0x30
>  [<ffffffff8105e4f2>] ? kthread+0x0/0x87
>  [<ffffffff810039d0>] ? kernel_thread_helper+0x0/0x10
> Code: 24 e8 26 00 00 45 31 ed 3b 98 28 01 00 00 73 39 89 db 48 8d 95 40 ff ff ff 48 8b 84 d8 30 01 00 00 bb 0c 00 00 00 48 85 c0 74
> 1e <48> 8b 08 48 8d 70 e0 48 89 d7 41 ff c5 48 83 c2 30 0f 18 09 48
> RIP  [<ffffffffa0159c72>] kvm_set_irq+0x17e/0x24b [kvm]
> 
> This bug is triggered when guest is shutdown, is because we freed
> irq_routing before pit thread stopped
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Applied, thanks.
