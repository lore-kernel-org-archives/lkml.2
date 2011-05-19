Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460Ab1ESTvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:51:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23880 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926Ab1ESTvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:51:46 -0400
Message-ID: <4DD574BE.7050709@kernel.org>
Date: Thu, 19 May 2011 12:51:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110513162646.GW2258@linux.vnet.ibm.com> <20110516070808.GC24836@elte.hu> <20110516074822.GE2573@linux.vnet.ibm.com> <20110516115148.GA2421@elte.hu> <20110516122329.GA29356@elte.hu> <20110516212449.GJ2573@linux.vnet.ibm.com> <20110517024000.GA5026@nowhere> <4DD435C2.6040305@kernel.org> <20110518231314.GA1723@nowhere> <4DD49DAF.5080605@kernel.org> <20110519144740.GC1956@nowhere>
In-Reply-To: <20110519144740.GC1956@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DD574C4.00C3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 07:47 AM, Frederic Weisbecker wrote:
> Can you please test the following branch?
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 		rcu/debug
> 
> It's Paul's branch + the early_initcall fix + the following patch:
> 
> ---
> commit 14667f347dea62d9e5a08e0f614840e50f73002c
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Thu May 19 16:25:19 2011 +0200
> 
>     rcu: Trace dynticks internal values
>     
>     To debug some nasty count bug.
>     
>     Not-signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

[   85.194251] ------------[ cut here ]------------
[   85.194260] WARNING: at kernel/rcutree.c:353 rcu_enter_nohz+0x63/0xa5()
[   85.194262] Hardware name: Sun Fire X4800 M2 
[   85.194264] Modules linked in:
[   85.194268] Pid: 0, comm: swapper Tainted: G        W   2.6.39-tip-yh-05046-g8a9149b-dirty #1021
[   85.194270] Call Trace:
[   85.194291]  [<ffffffff810800f4>] warn_slowpath_common+0x85/0x9d
[   85.194296]  [<ffffffff81080126>] warn_slowpath_null+0x1a/0x1c
[   85.194301]  [<ffffffff810d3326>] rcu_enter_nohz+0x63/0xa5
[   85.194311]  [<ffffffff810ab161>] tick_nohz_stop_sched_tick+0x27d/0x366
[   85.194317]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
[   85.194326]  [<ffffffff81bda823>] rest_init+0xb7/0xbe
[   85.194331]  [<ffffffff81bda76c>] ? csum_partial_copy_generic+0x16c/0x16c
[   85.194338]  [<ffffffff82742e39>] start_kernel+0x3b2/0x3bd
[   85.194344]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
[   85.194348]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
[   85.194351] ---[ end trace a7919e7f17c0a726 ]---
[   85.194366] Dumping ftrace buffer:
[   85.194391] ---------------------------------
[   85.194415] CPU:0 [LOST 74512 EVENTS]
[   85.194416]   <idle>-0       0d... 85121004us : <stack trace>
[   85.194418]  => rcu_irq_enter
[   85.194418]  => irq_enter
[   85.194419]  => smp_apic_timer_interrupt
[   85.194420]  => apic_timer_interrupt
[   85.194421]  => cpu_idle
[   85.194421]  => rest_init
[   85.194422]  => start_kernel
[   85.194423]  => x86_64_start_reservations
[   85.194430]   <idle>-0       0d... 85121009us : rcu_irq_enter: 1 49
[   85.194441]   <idle>-0       0dN.. 85121429us : <stack trace>
[   85.194443]  => rcu_irq_exit
[   85.194443]  => irq_exit
[   85.194444]  => smp_apic_timer_interrupt
[   85.194445]  => apic_timer_interrupt
[   85.194446]  => cpu_idle
[   85.194447]  => rest_init
[   85.194447]  => start_kernel
[   85.194448]  => x86_64_start_reservations
[   85.194454]   <idle>-0       0dN.. 85121433us : rcu_irq_exit: 1 4a
[   85.194465]   <idle>-0       0d... 85124995us : <stack trace>
[   85.194466]  => rcu_irq_enter
[   85.194467]  => irq_enter
[   85.194468]  => smp_apic_timer_interrupt
[   85.194469]  => apic_timer_interrupt
[   85.194470]  => cpu_idle
[   85.194470]  => rest_init
[   85.194471]  => start_kernel
[   85.194472]  => x86_64_start_reservations
[   85.194477]   <idle>-0       0d... 85125007us : rcu_irq_enter: 1 49
[   85.194488]   <idle>-0       0dN.. 85125366us : <stack trace>
[   85.194489]  => rcu_irq_exit
[   85.194490]  => irq_exit
[   85.194491]  => smp_apic_timer_interrupt
[   85.194492]  => apic_timer_interrupt
[   85.194492]  => cpu_idle
[   85.194493]  => rest_init
[   85.194494]  => start_kernel
[   85.194494]  => x86_64_start_reservations
[   85.194500]   <idle>-0       0dN.. 85125371us : rcu_irq_exit: 1 4a
[   85.194511]   <idle>-0       0d... 85128990us : <stack trace>
[   85.194512]  => rcu_irq_enter
[   85.194513]  => irq_enter
[   85.194514]  => smp_apic_timer_interrupt
[   85.194514]  => apic_timer_interrupt
[   85.194515]  => cpu_idle
[   85.194516]  => rest_init
[   85.194517]  => start_kernel
[   85.194517]  => x86_64_start_reservations
[   85.194523]   <idle>-0       0d... 85129001us : rcu_irq_enter: 1 49
[   85.194534]   <idle>-0       0dN.. 85129033us : <stack trace>
[   85.194535]  => rcu_irq_exit
[   85.194536]  => irq_exit
[   85.194536]  => smp_apic_timer_interrupt
[   85.194537]  => apic_timer_interrupt
[   85.194538]  => cpu_idle
[   85.194539]  => rest_init
[   85.194539]  => start_kernel
[   85.194540]  => x86_64_start_reservations
[   85.194546]   <idle>-0       0dN.. 85129043us : rcu_irq_exit: 1 4a
[   85.194556]   <idle>-0       0d... 85132981us : <stack trace>
[   85.194558]  => rcu_irq_enter
[   85.194558]  => irq_enter
[   85.194559]  => smp_apic_timer_interrupt
[   85.194560]  => apic_timer_interrupt
[   85.194561]  => cpu_idle
[   85.194561]  => rest_init
[   85.194562]  => start_kernel
[   85.194563]  => x86_64_start_reservations
[   85.194568]   <idle>-0       0d... 85132986us : rcu_irq_enter: 1 49
[   85.194579]   <idle>-0       0dN.. 85133066us : <stack trace>
[   85.194580]  => rcu_irq_exit
[   85.194581]  => irq_exit
[   85.194582]  => smp_apic_timer_interrupt
[   85.194583]  => apic_timer_interrupt
[   85.194583]  => cpu_idle
[   85.194584]  => rest_init
[   85.194585]  => start_kernel
[   85.194586]  => x86_64_start_reservations
[   85.194592]   <idle>-0       0dN.. 85133077us : rcu_irq_exit: 1 4a
[   85.194602]   <idle>-0       0d... 85136976us : <stack trace>
[   85.194604]  => rcu_irq_enter
[   85.194604]  => irq_enter
[   85.194605]  => smp_apic_timer_interrupt
[   85.194606]  => apic_timer_interrupt
[   85.194607]  => cpu_idle
[   85.194608]  => rest_init
[   85.194608]  => start_kernel
[   85.194609]  => x86_64_start_reservations
[   85.194615]   <idle>-0       0d... 85136987us : rcu_irq_enter: 1 49
[   85.194626]   <idle>-0       0dN.. 85137062us : <stack trace>
[   85.194627]  => rcu_irq_exit
[   85.194628]  => irq_exit
[   85.194628]  => smp_apic_timer_interrupt
[   85.194629]  => apic_timer_interrupt
[   85.194630]  => cpu_idle
[   85.194631]  => rest_init
[   85.194631]  => start_kernel
[   85.194632]  => x86_64_start_reservations
[   85.194638]   <idle>-0       0dN.. 85137072us : rcu_irq_exit: 1 4a
[   85.194649]   <idle>-0       0d... 85140967us : <stack trace>
[   85.194650]  => rcu_irq_enter
[   85.194651]  => irq_enter
[   85.194651]  => smp_apic_timer_interrupt
[   85.194652]  => apic_timer_interrupt
[   85.194653]  => cpu_idle
[   85.194653]  => rest_init
[   85.194654]  => start_kernel
[   85.194655]  => x86_64_start_reservations
[   85.194661]   <idle>-0       0d... 85140974us : rcu_irq_enter: 1 49
[   85.194671]   <idle>-0       0dN.. 85141463us : <stack trace>
[   85.194673]  => rcu_irq_exit
[   85.194673]  => irq_exit
[   85.194674]  => smp_apic_timer_interrupt
[   85.194675]  => apic_timer_interrupt
[   85.194676]  => cpu_idle
[   85.194676]  => rest_init
[   85.194677]  => start_kernel
[   85.194678]  => x86_64_start_reservations
[   85.194683]   <idle>-0       0dN.. 85141467us : rcu_irq_exit: 1 4a
[   85.194694]   <idle>-0       0d... 85144960us : <stack trace>
[   85.194695]  => rcu_irq_enter
[   85.194696]  => irq_enter
[   85.194697]  => smp_apic_timer_interrupt
[   85.194698]  => apic_timer_interrupt
[   85.194698]  => cpu_idle
[   85.194699]  => rest_init
[   85.194700]  => start_kernel
[   85.194700]  => x86_64_start_reservations
[   85.194706]   <idle>-0       0d... 85144967us : rcu_irq_enter: 1 49
[   85.194717]   <idle>-0       0dN.. 85145234us : <stack trace>
[   85.194718]  => rcu_irq_exit
[   85.194719]  => irq_exit
[   85.194720]  => smp_apic_timer_interrupt
[   85.194720]  => apic_timer_interrupt
[   85.194721]  => cpu_idle
[   85.194722]  => rest_init
[   85.194722]  => start_kernel
[   85.194723]  => x86_64_start_reservations
[   85.194729]   <idle>-0       0dN.. 85145238us : rcu_irq_exit: 1 4a
[   85.194740]   <idle>-0       0d... 85148953us : <stack trace>
[   85.194741]  => rcu_irq_enter
[   85.194742]  => irq_enter
[   85.194742]  => smp_apic_timer_interrupt
[   85.194743]  => apic_timer_interrupt
[   85.194744]  => cpu_idle
[   85.194744]  => rest_init
[   85.194745]  => start_kernel
[   85.194746]  => x86_64_start_reservations
[   85.194752]   <idle>-0       0d... 85148958us : rcu_irq_enter: 1 49
[   85.194762]   <idle>-0       0dN.. 85149096us : <stack trace>
[   85.194764]  => rcu_irq_exit
[   85.194764]  => irq_exit
[   85.194765]  => smp_apic_timer_interrupt
[   85.194766]  => apic_timer_interrupt
[   85.194767]  => cpu_idle
[   85.194767]  => rest_init
[   85.194768]  => start_kernel
[   85.194769]  => x86_64_start_reservations
[   85.194774]   <idle>-0       0dN.. 85149101us : rcu_irq_exit: 1 4a
[   85.194785]   <idle>-0       0d... 85152946us : <stack trace>
[   85.194786]  => rcu_irq_enter
[   85.194787]  => irq_enter
[   85.194788]  => smp_apic_timer_interrupt
[   85.194789]  => apic_timer_interrupt
[   85.194789]  => cpu_idle
[   85.194790]  => rest_init
[   85.194791]  => start_kernel
[   85.194791]  => x86_64_start_reservations
[   85.194797]   <idle>-0       0d... 85152953us : rcu_irq_enter: 1 49
[   85.194808]   <idle>-0       0dN.. 85153081us : <stack trace>
[   85.194809]  => rcu_irq_exit
[   85.194810]  => irq_exit
[   85.194811]  => smp_apic_timer_interrupt
[   85.194812]  => apic_timer_interrupt
[   85.194813]  => cpu_idle
[   85.194813]  => rest_init
[   85.194814]  => start_kernel
[   85.194815]  => x86_64_start_reservations
[   85.194821]   <idle>-0       0dN.. 85153085us : rcu_irq_exit: 1 4a
[   85.194832]   <idle>-0       0d... 85156939us : <stack trace>
[   85.194833]  => rcu_irq_enter
[   85.194834]  => irq_enter
[   85.194834]  => smp_apic_timer_interrupt
[   85.194835]  => apic_timer_interrupt
[   85.194836]  => cpu_idle
[   85.194837]  => rest_init
[   85.194837]  => start_kernel
[   85.194838]  => x86_64_start_reservations
[   85.194844]   <idle>-0       0d... 85156948us : rcu_irq_enter: 1 49
[   85.194854]   <idle>-0       0dN.. 85157535us : <stack trace>
[   85.194856]  => rcu_irq_exit
[   85.194856]  => irq_exit
[   85.194857]  => smp_apic_timer_interrupt
[   85.194858]  => apic_timer_interrupt
[   85.194859]  => cpu_idle
[   85.194859]  => rest_init
[   85.194860]  => start_kernel
[   85.194861]  => x86_64_start_reservations
[   85.194866]   <idle>-0       0dN.. 85157540us : rcu_irq_exit: 1 4a
[   85.194877]   <idle>-0       0d... 85160932us : <stack trace>
[   85.194878]  => rcu_irq_enter
[   85.194879]  => irq_enter
[   85.194880]  => smp_apic_timer_interrupt
[   85.194881]  => apic_timer_interrupt
[   85.194881]  => cpu_idle
[   85.194882]  => rest_init
[   85.194883]  => start_kernel
[   85.194883]  => x86_64_start_reservations
[   85.194889]   <idle>-0       0d... 85160941us : rcu_irq_enter: 1 49
[   85.194900]   <idle>-0       0dN.. 85161127us : <stack trace>
[   85.194901]  => rcu_irq_exit
[   85.194902]  => irq_exit
[   85.194903]  => smp_apic_timer_interrupt
[   85.194903]  => apic_timer_interrupt
[   85.194904]  => cpu_idle
[   85.194905]  => rest_init
[   85.194905]  => start_kernel
[   85.194906]  => x86_64_start_reservations
[   85.194912]   <idle>-0       0dN.. 85161132us : rcu_irq_exit: 1 4a
[   85.194923]   <idle>-0       0d... 85164925us : <stack trace>
[   85.194924]  => rcu_irq_enter
[   85.194925]  => irq_enter
[   85.194925]  => smp_apic_timer_interrupt
[   85.194926]  => apic_timer_interrupt
[   85.194927]  => cpu_idle
[   85.194928]  => rest_init
[   85.194928]  => start_kernel
[   85.194929]  => x86_64_start_reservations
[   85.194935]   <idle>-0       0d... 85164930us : rcu_irq_enter: 1 49
[   85.194945]   <idle>-0       0dN.. 85165009us : <stack trace>
[   85.194947]  => rcu_irq_exit
[   85.194947]  => irq_exit
[   85.194948]  => smp_apic_timer_interrupt
[   85.194949]  => apic_timer_interrupt
[   85.194950]  => cpu_idle
[   85.194950]  => rest_init
[   85.194951]  => start_kernel
[   85.194952]  => x86_64_start_reservations
[   85.194957]   <idle>-0       0dN.. 85165013us : rcu_irq_exit: 1 4a
[   85.194968]   <idle>-0       0d... 85168920us : <stack trace>
[   85.194969]  => rcu_irq_enter
[   85.194970]  => irq_enter
[   85.194971]  => smp_apic_timer_interrupt
[   85.194972]  => apic_timer_interrupt
[   85.194972]  => cpu_idle
[   85.194973]  => rest_init
[   85.194974]  => start_kernel
[   85.194974]  => x86_64_start_reservations
[   85.194980]   <idle>-0       0d... 85168931us : rcu_irq_enter: 1 49
[   85.194991]   <idle>-0       0dN.. 85168970us : <stack trace>
[   85.194992]  => rcu_irq_exit
[   85.194993]  => irq_exit
[   85.194993]  => smp_apic_timer_interrupt
[   85.194994]  => apic_timer_interrupt
[   85.194995]  => cpu_idle
[   85.194996]  => rest_init
[   85.194996]  => start_kernel
[   85.194997]  => x86_64_start_reservations
[   85.195003]   <idle>-0       0dN.. 85168980us : rcu_irq_exit: 1 4a
[   85.195014]   <idle>-0       0d... 85172911us : <stack trace>
[   85.195015]  => rcu_irq_enter
[   85.195016]  => irq_enter
[   85.195016]  => smp_apic_timer_interrupt
[   85.195017]  => apic_timer_interrupt
[   85.195018]  => cpu_idle
[   85.195019]  => rest_init
[   85.195020]  => start_kernel
[   85.195020]  => x86_64_start_reservations
[   85.195026]   <idle>-0       0d... 85172916us : rcu_irq_enter: 1 49
[   85.195037]   <idle>-0       0dN.. 85173155us : <stack trace>
[   85.195038]  => rcu_irq_exit
[   85.195039]  => irq_exit
[   85.195040]  => smp_apic_timer_interrupt
[   85.195041]  => apic_timer_interrupt
[   85.195042]  => cpu_idle
[   85.195042]  => rest_init
[   85.195043]  => start_kernel
[   85.195044]  => x86_64_start_reservations
[   85.195050]   <idle>-0       0dN.. 85173160us : rcu_irq_exit: 1 4a
[   85.195060]   <idle>-0       0d... 85176904us : <stack trace>
[   85.195061]  => rcu_irq_enter
[   85.195062]  => irq_enter
[   85.195063]  => smp_apic_timer_interrupt
[   85.195064]  => apic_timer_interrupt
[   85.195064]  => cpu_idle
[   85.195065]  => rest_init
[   85.195066]  => start_kernel
[   85.195066]  => x86_64_start_reservations
[   85.195072]   <idle>-0       0d... 85176913us : rcu_irq_enter: 1 49
[   85.195083]   <idle>-0       0dN.. 85177864us : <stack trace>
[   85.195084]  => rcu_irq_exit
[   85.195085]  => irq_exit
[   85.195086]  => smp_apic_timer_interrupt
[   85.195086]  => apic_timer_interrupt
[   85.195087]  => cpu_idle
[   85.195088]  => rest_init
[   85.195088]  => start_kernel
[   85.195089]  => x86_64_start_reservations
[   85.195095]   <idle>-0       0dN.. 85177869us : rcu_irq_exit: 1 4a
[   85.195106]   <idle>-0       0d... 85180897us : <stack trace>
[   85.195107]  => rcu_irq_enter
[   85.195108]  => irq_enter
[   85.195108]  => smp_apic_timer_interrupt
[   85.195109]  => apic_timer_interrupt
[   85.195110]  => cpu_idle
[   85.195111]  => rest_init
[   85.195111]  => start_kernel
[   85.195112]  => x86_64_start_reservations
[   85.195118]   <idle>-0       0d... 85180907us : rcu_irq_enter: 1 49
[   85.195129]   <idle>-0       0dN.. 85181665us : <stack trace>
[   85.195130]  => rcu_irq_exit
[   85.195130]  => irq_exit
[   85.195131]  => smp_apic_timer_interrupt
[   85.195132]  => apic_timer_interrupt
[   85.195133]  => cpu_idle
[   85.195133]  => rest_init
[   85.195134]  => start_kernel
[   85.195135]  => x86_64_start_reservations
[   85.195141]   <idle>-0       0dN.. 85181669us : rcu_irq_exit: 1 4a
[   85.195152]   <idle>-0       0d... 85184890us : <stack trace>
[   85.195153]  => rcu_irq_enter
[   85.195154]  => irq_enter
[   85.195154]  => smp_apic_timer_interrupt
[   85.195155]  => apic_timer_interrupt
[   85.195156]  => cpu_idle
[   85.195157]  => rest_init
[   85.195157]  => start_kernel
[   85.195158]  => x86_64_start_reservations
[   85.195164]   <idle>-0       0d... 85184895us : rcu_irq_enter: 1 49
[   85.195175]   <idle>-0       0dN.. 85185146us : <stack trace>
[   85.195176]  => rcu_irq_exit
[   85.195177]  => irq_exit
[   85.195177]  => smp_apic_timer_interrupt
[   85.195178]  => apic_timer_interrupt
[   85.195179]  => cpu_idle
[   85.195179]  => rest_init
[   85.195180]  => start_kernel
[   85.195181]  => x86_64_start_reservations
[   85.195187]   <idle>-0       0dN.. 85185151us : rcu_irq_exit: 1 4a
[   85.195203]    <...>-6       0d... 85188881us : <stack trace>
[   85.195204]  => rcu_irq_enter
[   85.195205]  => irq_enter
[   85.195206]  => smp_apic_timer_interrupt
[   85.195206]  => apic_timer_interrupt
[   85.195207]  => cpu_stopper_thread
[   85.195208]  => kthread
[   85.195209]  => kernel_thread_helper
[   85.195215]    <...>-6       0d... 85188894us : rcu_irq_enter: 1 49
[   85.195225]    <...>-6       0d... 85188982us : <stack trace>
[   85.195226]  => rcu_irq_exit
[   85.195227]  => irq_exit
[   85.195228]  => smp_apic_timer_interrupt
[   85.195229]  => apic_timer_interrupt
[   85.195230]  => cpu_stopper_thread
[   85.195231]  => kthread
[   85.195231]  => kernel_thread_helper
[   85.195237]    <...>-6       0d... 85188989us : rcu_irq_exit: 1 4a
[   85.195249]   <idle>-0       0d... 85190288us : <stack trace>
[   85.195250]  => rcu_irq_enter
[   85.195251]  => irq_enter
[   85.195251]  => do_IRQ
[   85.195252]  => ret_from_intr
[   85.195253]  => cpu_idle
[   85.195253]  => rest_init
[   85.195254]  => start_kernel
[   85.195255]  => x86_64_start_reservations
[   85.195261]   <idle>-0       0d... 85190299us : rcu_irq_enter: 1 49
[   85.195271]   <idle>-0       0d... 85190336us : <stack trace>
[   85.195272]  => rcu_irq_exit
[   85.195273]  => irq_exit
[   85.195274]  => do_IRQ
[   85.195274]  => ret_from_intr
[   85.195275]  => cpu_idle
[   85.195276]  => rest_init
[   85.195276]  => start_kernel
[   85.195277]  => x86_64_start_reservations
[   85.195283]   <idle>-0       0d... 85190346us : rcu_irq_exit: 1 4a
[   85.195293]   <idle>-0       0d... 85192902us : <stack trace>
[   85.195295]  => rcu_irq_enter
[   85.195295]  => irq_enter
[   85.195296]  => smp_apic_timer_interrupt
[   85.195297]  => apic_timer_interrupt
[   85.195298]  => cpu_idle
[   85.195298]  => rest_init
[   85.195299]  => start_kernel
[   85.195300]  => x86_64_start_reservations
[   85.195305]   <idle>-0       0d... 85193714us : rcu_irq_enter: 1 49
[   85.195316]   <idle>-0       0dN.. 85193856us : <stack trace>
[   85.195317]  => rcu_irq_exit
[   85.195318]  => irq_exit
[   85.195319]  => smp_apic_timer_interrupt
[   85.195320]  => apic_timer_interrupt
[   85.195320]  => cpu_idle
[   85.195321]  => rest_init
[   85.195322]  => start_kernel
[   85.195322]  => x86_64_start_reservations
[   85.195328]   <idle>-0       0dN.. 85194210us : rcu_irq_exit: 1 4a
[   85.195338]   <idle>-0       0d... 85194247us : <stack trace>
[   85.195340]  => rcu_enter_nohz
[   85.195340]  => tick_nohz_stop_sched_tick
[   85.195341]  => cpu_idle
[   85.195342]  => rest_init
[   85.195342]  => start_kernel
[   85.195343]  => x86_64_start_reservations
[   85.195344]  => x86_64_start_kernel
[   85.195350]   <idle>-0       0d... 85194250us : rcu_enter_nohz: 1 49
[   85.195352] ---------------------------------
