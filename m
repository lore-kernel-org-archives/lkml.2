Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab0HDO4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:56:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39567 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab0HDO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:56:29 -0400
Subject: Re: 2.6.35-stable/ppc64/p7: suspicious rcu_dereference_check()
	usage detected during 2.6.35-stable boot
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Cc: sachinp <sachinp@linux.vnet.ibm.com>,
        DIVYA PRAKASH <dipraksh@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1280739132.15317.9.camel@subratamodak.linux.ibm.com>
References: <1280739132.15317.9.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 04 Aug 2010 20:26:06 +0530
Message-Id: <1280933767.8392.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter/Li,

Did you get a chance to see this ?

Regards--
Subrata

On Mon, 2010-08-02 at 14:22 +0530, Subrata Modak wrote:
> Hi,
> 
> The following suspicious rcu_dereference_check() usage is detected
> during 2.6.35-stable boot on my ppc64/p7 machine:
> 
> ==================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/sched.c:616 invoked rcu_dereference_check() without protection!
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 1 lock held by swapper/1:
>  #0:  (&rq->lock){-.....}, at: [<c0000000007ca2f8>] .init_idle+0x78/0x4a8
> stack backtrace:
> Call Trace:
> [c000000f392bf990] [c000000000014f04] .show_stack+0xb0/0x1a0 (unreliable)
> [c000000f392bfa50] [c0000000007c87b4] .dump_stack+0x28/0x3c
> [c000000f392bfad0] [c000000000103e1c] .lockdep_rcu_dereference+0xbc/0xe4
> [c000000f392bfb70] [c0000000007ca434] .init_idle+0x1b4/0x4a8
> [c000000f392bfc30] [c0000000007cad04] .fork_idle+0xa4/0xd0
> [c000000f392bfe30] [c000000000aefaac] .smp_prepare_cpus+0x23c/0x2f4
> [c000000f392bfed0] [c000000000ae1424] .kernel_init+0xec/0x32c
> [c000000f392bff90] [c000000000033f40] .kernel_thread+0x54/0x70
> ==================================================
> 
> Please note that this was reported earlier on 2.6.34-rc6:
> http://marc.info/?l=linux-kernel&m=127313031922395&w=2,
> The issue was fixed with:
> 	commit 1ce7e4ff24fe338438bc7837e02780f202bf202b
> 	Author: Li Zefan <lizf@cn.fujitsu.com>
> 	Date:   Fri Apr 23 10:35:52 2010 +0800
> 	cgroup: Check task_lock in task_subsys_state()
> 
> According to:
> 	http://lkml.org/lkml/2010/7/1/883,
> 	commit dc61b1d65e353d638b2445f71fb8e5b5630f2415
> 	Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 	Date:   Tue Jun 8 11:40:42 2010 +0200
> 	sched: Fix PROVE_RCU vs cpu_cgroup
> should have fixed this. But this is reproducible on 2.6.35-stable.
> 
> Please also see the config file attached.
> 
> Regards--
> Subrata
> 

