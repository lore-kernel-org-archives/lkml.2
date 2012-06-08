Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab2FHJE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:04:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33025 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab2FHJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:04:23 -0400
Date: Fri, 8 Jun 2012 11:04:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/7] RCU_FAST_NO_HZ changes for 3.6
Message-ID: <20120608090417.GA10841@gmail.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608042632.GA1250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> This patch series provides more adjustments to the (relatively) new
> large-system-safe implementation for RCU_FAST_NO_HZ:
> 
> 1.	Remove RCU_FAST_NO_HZ dependency on stop_machine() nature of
> 	CPU hotplug.
> 2.	Make RCU_FAST_NO_HZ tracing distinguish between short and
> 	long idle intervals.
> 3.	Move RCU_FAST_NO_HZ per-CPU state variables to the rcu_dynticks
> 	per-CPU structure.
> 4.	Precompute RCU_FAST_NO_HZ timer offsets so that the timers
> 	will actually be paid attention to.  This fixes the slow-boot
> 	problem that hit a few people.
> 5.	Convert ftrace_dump() calls in idle entry and idle exit from
> 	DUMP_ALL to DUMP_ORIG.
> 6.	Fix erroneous TINY_PREEMPT_RCU assumption that rcu_preempt_needs_cpu()
> 	is a quiescent state (it is not).
> 7.	Round RCU_FAST_NO_HZ lazy timeout to nearest second to conserve
> 	power on systems with synchronized scheduler-clock interrupts.
> 
> I am considering pushing #1-#4 into 3.5 for the slow-boot regression.
> If you object, please let me know.

Sure, that's sensible - could get this to me ASAP so that we can 
send it to Linus before -rc2? #3 and #4 are pretty large so we 
want them upstream ASAP.

Thanks,

	Ingo
