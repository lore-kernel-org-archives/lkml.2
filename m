Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab2FMJW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:22:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37560 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2FMJW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAORVsuWGE3=8DWRMG0Fq2+CGt9i7__JnfUnOAjbZgGcvhfVK5g@mail.gmail.com>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
	<CAORVsuWGE3=8DWRMG0Fq2+CGt9i7__JnfUnOAjbZgGcvhfVK5g@mail.gmail.com>
Date: Wed, 13 Jun 2012 11:22:56 +0200
Message-ID: <CAKfTPtD8315c8o2354SoRLvUg2OEwjsuE2uwO+LKu=aT_EhELQ@mail.gmail.com>
Subject: Re: [RFC 1/4] ARM: topology: Add arch_scale_freq_power function
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, peterz@infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 10:50, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> Hi Vincent,
>
> On Tue, Jun 12, 2012 at 2:02 PM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> Add infrastructure to be able to modify the cpu_power of each core
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/arm/include/asm/topology.h |    2 ++
>>  arch/arm/kernel/topology.c      |   36 +++++++++++++++++++++++++++++++++++-
>>  2 files changed, 37 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
>> index 58b8b84..78e4c85 100644
>> --- a/arch/arm/include/asm/topology.h
>> +++ b/arch/arm/include/asm/topology.h
>> @@ -27,11 +27,13 @@ void init_cpu_topology(void);
>>  void store_cpu_topology(unsigned int cpuid);
>>  const struct cpumask *cpu_coregroup_mask(int cpu);
>>
>> +void set_power_scale(unsigned int cpu, unsigned long power);
>>  #else
>>
>>  static inline void init_cpu_topology(void) { }
>>  static inline void store_cpu_topology(unsigned int cpuid) { }
>>
>> +static inline void set_power_scale(unsigned int cpu, unsigned long power) { }
>>  #endif
>>
>>  #include <asm-generic/topology.h>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index 8200dea..00301a7 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -22,6 +22,35 @@
>>  #include <asm/cputype.h>
>>  #include <asm/topology.h>
>>
>> +/*
>> + * cpu power scale management
>> + */
>> +
>> +/*
>> + * cpu power table
>> + * This per cpu data structure describes the relative capacity of each core.
>> + * On a heteregenous system, cores don't have the same computation capacity
>> + * and we reflect that difference in the cpu_power field so the scheduler can
>> + * take this difference into account for load balance. A per cpu structure is
>> + * preferred because each cpu is mainly using its own cpu_power even it's not
>> + * always true because of nohz_idle_balance
> The end of the comment is unclear IMO; Can you give more details on
> the relation between cpu_power and nohz_idle_balance?

When several cores are idle, one core runs the load balance for all
idle cores. The update of the cpu_power can be done during rebalance
and arch_scale_freq_power can be called by CPU0 for updating the
cpu_power of CPU1.

I was probably not clear enough in my first explanation. I will reword
the comment

Regards,
Vincent
>
> Regards,
> Jean
