Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1DLG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:26:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47826
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504Ab1DLG0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:26:20 -0400
Date: Mon, 11 Apr 2011 23:25:43 -0700 (PDT)
Message-Id: <20110411.232543.193698090.davem@davemloft.net>
To: mingo@elte.hu
Cc: sfr@canb.auug.org.au, tglx@linutronix.de, hpa@zytor.com,
        peterz@infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110412062002.GA31050@elte.hu>
References: <20110412140040.3020ef55.sfr@canb.auug.org.au>
	<20110412062002.GA31050@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 12 Apr 2011 08:20:02 +0200

> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi all,
>> 
>> After merging the final tree, today's linux-next build (sparc64 defconfig)
>> failed like this:
>> 
>> kernel/sched.c:7140: error: 'cpu_coregroup_mask' undeclared here (not in a function)
>> 
>> Caused by commit 2c402dc3bb50 ("sched: Unify the sched_domain build
>> functions").  On sparc64, cpu_coregroup_mask is a #define, not a function.
>> 
>> I applied tha patch below (idea stolen from s390) whcih could probably be
>> better.
>> 
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Tue, 12 Apr 2011 13:51:32 +1000
>> Subject: [PATCH] sched: fix sparc64 for sched_domain changes
>> 
>> Fixes this compile error:
>> 
>> kernel/sched.c:7140: error: 'cpu_coregroup_mask' undeclared here (not in a function)
>> 
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  arch/sparc/include/asm/topology_64.h |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>> 
>> diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
>> index 1c79f32..16f477d 100644
>> --- a/arch/sparc/include/asm/topology_64.h
>> +++ b/arch/sparc/include/asm/topology_64.h
>> @@ -65,6 +65,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
>>  #define smt_capable()				(sparc64_multi_core)
>>  #endif /* CONFIG_SMP */
>>  
>> -#define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
>> +extern cpumask_t cpu_core_map[NR_CPUS];
>> +static inline const struct cpumask *cpu_coregroup_mask(int cpu)
>> +{
>> +        return &cpu_core_map[cpu];
>> +}
> 
> Dave, if this change is fine with you i'd like to queue it up in 
> tip:sched/domains.

Yep, it's fine:

Acked-by: David S. Miller <davem@davemloft.net>
