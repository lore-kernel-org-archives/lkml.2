Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2CVJUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:20:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46040 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2CVJUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:20:45 -0400
Message-ID: <1332408023.18960.503.camel@twins>
Subject: Re: [PATCH] xen/smp: Fix bringup bug in AP code.
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
        tglx@linutronix.de, xen-devel@lists.xensource.com
Date: Thu, 22 Mar 2012 10:20:23 +0100
In-Reply-To: <1332385449-29281-2-git-send-email-konrad.wilk@oracle.com>
References: <1332347541.18960.498.camel@twins>
	 <1332385449-29281-1-git-send-email-konrad.wilk@oracle.com>
	 <1332385449-29281-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 23:04 -0400, Konrad Rzeszutek Wilk wrote:
> The CPU hotplug code has now a callback to help bring up the CPU.
> Without the call we end up getting:

Its had this for a while now (since 2008, see e545a614). Its just that
generic infrastructure started using it only now.

>  BUG: soft lockup - CPU#0 stuck for 29s! [migration/0:6]
> Modules linked in:
> CPU ] Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
> RIP: e030:[<ffffffff810d3b8b>]  [<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf0
> RSP: e02b:ffff8800ceaabdb0  EFLAGS: 00000293
> .. snip..
> Call Trace:
>  [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
>  [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
>  [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
>  [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
>  [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
>  [<ffffffff8108dc76>] kthread+0x96/0xa0
>  [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff815aacbc>] ? retint_restore_ar
> 
> This fixes it.
> 
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
