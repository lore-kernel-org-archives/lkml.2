Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2AQCvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:51:18 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43392 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2AQCvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:51:17 -0500
Message-ID: <4F14DFBC.7050908@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:41:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] KVM: perf: a smart tool to analyse kvm events
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F14AA60.1040904@gmail.com>
In-Reply-To: <4F14AA60.1040904@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011616-0260-0000-0000-000000633B82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 06:53 AM, David Ahern wrote:

> 
> 
> On 01/16/2012 02:30 AM, Xiao Guangrong wrote:
>> This tool is very like xenoprof(if i remember correctly), and traces kvm events
>> smartly. currently, it supports vmexit/mmio/ioport events.
>>
>> Usage:
>> - to trace kvm events:
>> # ./perf kvm-events record
>>
>> - show the result
>> # ./perf kvm-events report
>>
>> Some output are as follow:
>> # ./perf kvm-events report
>>   Warning: Error: expected type 5 but read 4
>>   Warning: Error: expected type 5 but read 0
>>   Warning: unknown op '}'
> 
> Integrating the trace-cmd plugins into perf will remedy the above errors:
> https://lkml.org/lkml/2011/8/16/352
> 


Yes, it is great!

> Unfortunately, that effort is stalled at the moment.
> 
>>
>>
>> Analyze events for all VCPUs:
>>
>>              VM-EXIT    Samples      Samples%         Time%        Avg time
>>
>>          APIC_ACCESS     438107        44.89%         6.20%        17.91us
>>   EXTERNAL_INTERRUPT     219226        22.46%         8.01%        46.20us
>>       IO_INSTRUCTION     122651        12.57%         1.88%        19.44us
>>        EPT_VIOLATION      83110         8.52%         1.36%        20.75us
>>    PENDING_INTERRUPT      37055         3.80%         0.16%         5.38us
>>                CPUID      32718         3.35%         0.08%         3.15us
>>        EXCEPTION_NMI      23601         2.42%         0.17%         8.87us
>>                  HLT      15424         1.58%        82.12%      6735.06us
>>            CR_ACCESS       4089         0.42%         0.02%         6.08us
>>
>> Total Samples:975981, Total events handled time:126502464.88us.
> 
> Have you thought about dumping a time history -- something similar to
> what perf-script can do with dumping events but adding in kvm-specific
> analysis like what you are doing in these examples?
> 


I will look into it and put it to my todo list if it is possible.
Thanks, David!

