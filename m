Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab1IIGTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:19:11 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57206 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437Ab1IIGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:19:06 -0400
Message-ID: <4E69AFCF.3040404@linux.vnet.ibm.com>
Date: Fri, 09 Sep 2011 11:48:55 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Michael Neuling <michael.neuling@au1.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend
 events
References: <4E5C6A7D.2010909@linux.vnet.ibm.com> <25545.1315532289@neuling.org>
In-Reply-To: <25545.1315532289@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 07:08 AM, Michael Neuling wrote:
>> perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend events
>>
>> 	Extent the POWER7 PMU driver with definitions
>> 	for generic front-end and back-end stall events.
> 
> Anshuman,
> 
> Can you explain what these P7 events actually are and how they relate to
> Ingo's original comment on this in
> 8f62242246351b5a4bc0c1f00c0c7003edea128a
> 
>     Both events limit performance: most front end stalls tend to be
>     caused by branch misprediction or instruction fetch cachemisses,
>     backend stalls can be caused by various resource shortages or
>     inefficient instruction scheduling.
> 
As explained in Ingo's original comment, the exact definitions of the stall 
events are very much processor specific as different things mean different in
their respective instruction pipeline. These two Power7 raw events are the closest 
approximation to the concept detailed in Ingo's comment.    
>>
>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>>
>> diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
>> index 593740f..e5d2844 100644
>> --- a/arch/powerpc/kernel/power7-pmu.c
>> +++ b/arch/powerpc/kernel/power7-pmu.c
>> @@ -297,6 +297,8 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
>>  
>>  static int power7_generic_events[] = {
>>  	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
>> +	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */
> 
> eg. Is this Global Completion Table (GCT) empty?
Yes, it means cycles when the Global Completion Table has no slots from this thread
> 
>> +	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */
> 
> eg. Is this instruction completion stall?
Yes, it means no groups completed and GCT not empty
> 
> Mikey
> 
>>  	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
>>  	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
>>  	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
>>
>> -- 
>> Anshuman Khandual 
>>
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Anshuman Khandual 
LTC India 

