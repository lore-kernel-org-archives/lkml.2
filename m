Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2B1Rgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:36:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53687 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2B1Rgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:36:47 -0500
Message-ID: <4F4D10A9.5010707@gmail.com>
Date: Tue, 28 Feb 2012 10:36:41 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] perf/x86: Fix HO/GO counting with SVM disabled
References: <20120227182325.GA12302@8bytes.org> <1330444544-15665-1-git-send-email-joerg.roedel@amd.com> <4F4D0DD6.9030302@redhat.com>
In-Reply-To: <4F4D0DD6.9030302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/12 10:24 AM, Avi Kivity wrote:
> On 02/28/2012 05:55 PM, Joerg Roedel wrote:
>>
>>   __init int amd_pmu_init(void)
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 5fa553b..773fee2 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -29,6 +29,7 @@
>>   #include<linux/ftrace_event.h>
>>   #include<linux/slab.h>
>>
>> +#include<asm/perf_event.h>
>>   #include<asm/tlbflush.h>
>>   #include<asm/desc.h>
>>   #include<asm/kvm_para.h>
>> @@ -575,6 +576,8 @@ static void svm_hardware_disable(void *garbage)
>>   		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
>>
>>   	cpu_svm_disable();
>> +
>> +	x86_pmu_disable_virt();
>>   }
>>
>>   static int svm_hardware_enable(void *garbage)
>> @@ -622,6 +625,8 @@ static int svm_hardware_enable(void *garbage)
>>
>>   	svm_init_erratum_383();
>>
>> +	x86_pmu_enable_virt();
>> +
>>   	return 0;
>>   }
>>
>
> These should go into x86.c.  If the functions later gain meaning on
> Intel, we want them to be called (and nothing in the name suggests
> they're AMD specific).
>

I was to suggest the reverse: since this patch addesses an AMD bug, why 
not push those functions into perf_event_amd.c and make them dependent 
on CONFIG_CPU_SUP_AMD as well.

David
