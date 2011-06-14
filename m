Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1FNNPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:15:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1FNNPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:15:24 -0400
Subject: Re: rcu: performance regression
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, rostedt@goodmis.org
In-Reply-To: <20110614130203.GF2264@linux.vnet.ibm.com>
References: <1308029185.15392.147.camel@sli10-conroe>
	 <1308040388.21027.1847.camel@debian>
	 <20110614130203.GF2264@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 15:14:58 +0200
Message-ID: <1308057298.19856.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 06:02 -0700, Paul E. McKenney wrote:
> > This commit also cause hackbench process mode performance dropping, and
> > Shaohua's patch do recovered this. But in hackbench testing, the vmstat
> > show context switch have some reduce. And perf tool show
> > root_domain->cpupri->prio_to_cpu[]->lock has contention with the commit.
> 
> Steven, Peter, would any of the recent fixes address this lock contention? 

No. People occasionally run into that thing, but given the constraints
on SCHED_FIFO SMP (run the n highest priority tasks on m cpus; n<=m)
there isn't really much we can do.

IIRC Chris Mason once proposed a lockless version, but that opened up
race windows, Steve might know the details better.
