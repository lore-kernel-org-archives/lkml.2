Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1BWOzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:55:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1BWOzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:55:18 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=jNfASM90n5oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=sm3AeqNnQvzIxt51lBgA:9 a=UEp2HycnOxRSpl29hPiMVDN_Hh8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 05/11] rcu: add comment saying why
 DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
In-Reply-To: <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1298431409.7666.76.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 09:55:14 -0500
Message-ID: <1298472914.7666.85.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 08:59 -0500, Mathieu Desnoyers wrote:

> #ifdef CONFIG_PREEMPT
>                 /*
>                  * Ensure that queued callbacks are all executed.
>                  * If we detect that we are nested in a RCU read-side
>                  * critical
>                  * section, we should simply fail, otherwise we would
>                  * deadlock.
>                  */
>                 if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
>                     irqs_disabled()) {
>                         WARN_ON(1);
>                         return 0;
>                 }
>                 rcu_barrier();
>                 rcu_barrier_sched();
>                 rcu_barrier_bh();
>                 debug_object_init(head, &rcuhead_debug_descr);
>                 return 1;
> #else
> 		return 0;
> #endif
> 
> instead, no ?

BTW, if you do end up doing such a thing...

#ifndef CONFIG_PREEMPT
	return 0;
#endif

before all that would be much cleaner.

Just make sure any non defined in PREEMPT macros/functions are defined
as nops in !CONFIG_PREEMPT

-- Steve


