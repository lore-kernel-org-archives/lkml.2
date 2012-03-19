Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab2CSOdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:33:01 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51248 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2CSOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:33:00 -0400
Message-ID: <4F674178.90607@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 19:53:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC] rcu: Make rcu_barrier() less disruptive
References: <20120315164839.GA1657@linux.vnet.ibm.com>
In-Reply-To: <20120315164839.GA1657@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031914-8256-0000-0000-000001B54732
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Paul,

On 03/15/2012 10:18 PM, Paul E. McKenney wrote:

> The rcu_barrier() primitive interrupts each and every CPU, registering
> a callback on every CPU.  Once all of these callbacks have been invoked,
> rcu_barrier() knows that every callback that was registered before
> the call to rcu_barrier() has also been invoked.
> 
> However, there is no point in registering a callback on a CPU that
> currently has no callbacks, most especially if that CPU is in a
> deep idle state.  This commit therefore makes rcu_barrier() avoid
> interrupting CPUs that have no callbacks.  Doing this requires reworking
> the handling of orphaned callbacks, otherwise callbacks could slip through
> rcu_barrier()'s net by being orphaned from a CPU that rcu_barrier() had
> not yet interrupted to a CPU that rcu_barrier() had already interrupted.
> This reworking was needed anyway to take a first step towards weaning
> RCU from the CPU_DYING notifier's use of stop_cpu().
> 

s/stop_cpu()/stop_machine() ?


Thank you for doing this! :-)

> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

