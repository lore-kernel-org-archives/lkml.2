Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2ICGFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 02:05:23 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48275 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2ICGFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:05:22 -0400
Message-ID: <50444897.6070803@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 14:05:11 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: rcu_bh stalls on 3.2.28
References: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk> <20120831230256.GA7016@khazad-dum.debian.net>
In-Reply-To: <20120831230256.GA7016@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090306-2674-0000-0000-000005D2A3C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2012 07:02 AM, Henrique de Moraes Holschuh wrote:
> Just got one of these:
> 
> kernel: INFO: rcu_bh detected stall on CPU 2 (t=0 jiffies)
> kernel: Pid: 0, comm: swapper/2 Not tainted 3.2.28+ #2
> kernel: Call Trace:
> kernel: <IRQ>  [<ffffffff810d1609>] __rcu_pending+0x159/0x400
> kernel: [<ffffffff810d20bb>] rcu_check_callbacks+0x9b/0x120
> kernel: [<ffffffff81089673>] update_process_times+0x43/0x80
> kernel: [<ffffffff810a836f>] tick_sched_timer+0x5f/0xb0
> kernel: [<ffffffff8109c097>] __run_hrtimer.isra.30+0x57/0x100
> kernel: [<ffffffff8109c8f5>] hrtimer_interrupt+0xe5/0x220
> kernel: [<ffffffff8104ce14>] smp_apic_timer_interrupt+0x64/0xa0
> kernel: [<ffffffff8159b5cb>] apic_timer_interrupt+0x6b/0x70
> kernel: <EOI>  [<ffffffff81315645>] ? intel_idle+0xe5/0x140
> kernel: [<ffffffff81315623>] ? intel_idle+0xc3/0x140
> kernel: [<ffffffff814420ee>] cpuidle_idle_call+0x8e/0xf0
> kernel: [<ffffffff81032425>] cpu_idle+0xa5/0x110
> kernel: [<ffffffff8158a9ac>] start_secondary+0x1e5/0x1ec

Hi, Henrique

rsp->gp_start and rsp->jiffies_stall should already set before we start
check stall for this gp, but the INFO show that we have a current
jiffies which bigger then rsp->jiffies_stall but equal to rsp->gp_start,
really strange...

Could you please have a try on the latest kernel and confirm whether
this issue still exist?

BTW:
	Is this stall info comes from a virtual machine?

Regards,
Michael Wang

> 
> There are previous reports of these weird rcu_bh stalls with t=0 in the 3.2
> and 3.3 branches as well:
> 
> https://lkml.org/lkml/2012/2/18/34
> http://lkml.org/lkml/2012/3/28/175
> 
> another data point:
> https://bugzilla.redhat.com/show_bug.cgi?id=806610
> 

