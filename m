Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab2GVJxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 05:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2GVJxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 05:53:09 -0400
Message-ID: <500BCD7A.4060108@redhat.com>
Date: Sun, 22 Jul 2012 12:52:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com> <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com> <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <5009EB16.1070809@gmail.com>
In-Reply-To: <5009EB16.1070809@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 02:34 AM, David Ahern wrote:
> On 7/11/12 1:10 AM, Gleb Natapov wrote:
>> Looks like Avi is right about the overshoot. Can you test something
>> like this?
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c
>> b/arch/x86/kernel/cpu/perf_event_intel.c
>> index 166546e..5fb371a 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -1374,8 +1374,11 @@ static struct perf_guest_switch_msr
>> *intel_guest_get_msrs(int *nr)
>>       arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>>       arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>>       arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
>> +    arr[1].msr = MSR_IA32_PEBS_ENABLE;
>> +    arr[1].host = cpuc->pebs_enabled;
>> +    arr[1].guest = 0;
>> +    *nr = 2;
>>
>> -    *nr = 1;
>>       return arr;
>>   }
> 
> 
> Tested-by: David Ahern <dsahern@gmail.com>

Thanks.

Gleb, please add a comment explaining about the skid, because otherwise
it looks redundant.


-- 
error compiling committee.c: too many arguments to function


