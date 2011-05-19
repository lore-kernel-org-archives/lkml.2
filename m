Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926Ab1ESVqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:46:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54746 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1ESVqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:46:07 -0400
Message-ID: <4DD58F90.4090506@kernel.org>
Date: Thu, 19 May 2011 14:45:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110516074822.GE2573@linux.vnet.ibm.com> <20110516115148.GA2421@elte.hu> <20110516122329.GA29356@elte.hu> <20110516212449.GJ2573@linux.vnet.ibm.com> <20110517024000.GA5026@nowhere> <4DD435C2.6040305@kernel.org> <20110518231314.GA1723@nowhere> <4DD49DAF.5080605@kernel.org> <20110519144740.GC1956@nowhere> <4DD574BE.7050709@kernel.org> <20110519211458.GG1956@nowhere>
In-Reply-To: <20110519211458.GG1956@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DD58F97.0089,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 02:15 PM, Frederic Weisbecker wrote:
> On Thu, May 19, 2011 at 12:51:26PM -0700, Yinghai Lu wrote:
>> [   85.194797]   <idle>-0       0d... 85152953us : rcu_irq_enter: 1 49
>> [   85.194808]   <idle>-0       0dN.. 85153081us : <stack trace>
>> [   85.194809]  => rcu_irq_exit
>> [   85.194810]  => irq_exit
>> [   85.194811]  => smp_apic_timer_interrupt
>> [   85.194812]  => apic_timer_interrupt
>> [   85.194813]  => cpu_idle
>> [   85.194813]  => rest_init
>> [   85.194814]  => start_kernel
>> [   85.194815]  => x86_64_start_reservations
> 
> So it's the dynticks_nesting going crazy. As if we had rcu_irq_enter()
> without rcu_irq_exit().
> 
> I see you have CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> and the locking api selftest is doing a strange thing: if we look
> at HARDIRQ_ENTER(), it calls irq_enter(), but HARDIRQ_EXIT() only
> calls __irq_exit(). Which means it lacks the rcu_irq_exit().
> 
> So, if I understood correctly the thing there, some selftests simulating
> the hardirq context are unbalancing the rcu state.
> 
> Does that help if you unset CONFIG_DEBUG_LOCKING_API_SELFTESTS ?


yes, after unset that, no warning and delay...

Thanks
