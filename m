Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab2CSSrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:47:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33789 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab2CSSro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:47:44 -0400
Message-ID: <1332182842.18960.376.camel@twins>
Subject: Re: [RFC] AutoNUMA alpha6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 19 Mar 2012 19:47:22 +0100
In-Reply-To: <20120316182511.GJ24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <20120316182511.GJ24602@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 19:25 +0100, Andrea Arcangeli wrote:
> http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=patch;h=30ed50adf6cfe85f7feb12c4279359ec52f5f2cd;hp=c03cf0621ed5941f7a9c1e0a343d4df30dbfb7a1
> 
> It's a big monlithic patch, but I'll split it.

I applied this big patch to a fairly recent tree from Linus but it
failed to boot. It got stuck somewhere in SMP bringup.

I waited for several seconds but pressed the remote power switch when
nothing more came out..

The last bit out of my serial console looked like:

---

Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 98000
cpu 1 node 0
cpu 1 apicid 2 node 0
Pid: 0, comm: swapper/1 Not tainted 3.3.0-rc7-00048-g762ad8a-dirty #32
Call Trace:
 [<ffffffff81942a37>] numa_set_node+0x50/0x6a
 [<ffffffff8193f0b4>] init_intel+0x13c/0x232
 [<ffffffff8193e50a>] ? get_cpu_cap+0xa3/0xa7
 [<ffffffff8193e74e>] identify_cpu+0x240/0x347
 [<ffffffff8193e869>] identify_secondary_cpu+0x14/0x1b
 [<ffffffff8194131b>] smp_store_cpu_info+0x3c/0x3e
 [<ffffffff8194176a>] start_secondary+0x109/0x21e
numa cpu 1 node 0
NMI watchdog enabled, takes one hw-pmu counter.
 #2
smpboot cpu 2: start_ip = 98000
cpu 2 node 0
cpu 2 apicid 4 node 0
Pid: 0, comm: swapper/2 Not tainted 3.3.0-rc7-00048-g762ad8a-dirty #32
Call Trace:
 [<ffffffff81942a37>] numa_set_node+0x50/0x6a
 [<ffffffff8193f0b4>] init_intel+0x13c/0x232
 [<ffffffff8193e50a>] ? get_cpu_cap+0xa3/0xa7
 [<ffffffff8193e74e>] identify_cpu+0x240/0x347
 [<ffffffff8193e869>] identify_secondary_cpu+0x14/0x1b
 [<ffffffff8194131b>] smp_store_cpu_info+0x3c/0x3e
 [<ffffffff8194176a>] start_secondary+0x109/0x21e
numa cpu 2 node 0
NMI
