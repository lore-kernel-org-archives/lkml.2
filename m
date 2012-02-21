Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2BUDxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 22:53:08 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54543 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BUDxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 22:53:06 -0500
Message-ID: <4F43150F.7010902@linux.vnet.ibm.com>
Date: Tue, 21 Feb 2012 11:52:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F338CAA.10807@linux.vnet.ibm.com> <4F338D56.6010505@linux.vnet.ibm.com> <4F42DB8D.7060900@gmail.com>
In-Reply-To: <4F42DB8D.7060900@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022017-5490-0000-0000-000000C6E087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 07:47 AM, David Ahern wrote:

- show the result:
>>     perf kvm-events report
> 
> It would be nice to have example reports in this commit message.
> 


Okay.

>> +DESCRIPTION
>> +-----------
>> +You can analyze some crucial kvm events and statistics with this
>> +'perf kvm-events' command. Currently, vmexit, mmio and ioport events
>> +are supported.
> First sentence should be written in the 3rd person. eg.,
> This command generates a statistical analysis of KVM events.
> 


Okay.

>> +--events=<value>::
>> +    events to be analyzed. Possible values: vmexit, mmio, ioport.
> 
> Add a comment stating which event type is the default.
> 


OK, will fix.

>>
>> +-k::
>> +--key=<value>::
>> +        Sorting key. Possible values: sample(default, sort by samples number),
>> +time(sort by average time).
> Space before both of the '('.
> 


Yes, will fix.

>> +static const char *get_exit_reason(u64 exit_code, int isa)
>> +{
>> +    int table_size = ARRAY_SIZE(svm_exit_reasons);
>> +    struct exit_reasons_table *table = svm_exit_reasons;
>> +
>> +    if (isa == 1) {
>> +        table = vmx_exit_reasons;
>> +        table_size = ARRAY_SIZE(vmx_exit_reasons);
>> +    }
> Why not use globals that are set once in read_events() after looking up cpu_isa? Then you don't have to state a preference on default init here -- AMD or Intel. And the isa argument will not be needed here.
> 


I agree.

>> +    #define DEFAULT_VCPU_NUM 32
> Why 32 for the default number of vcpus in a guest? Seems like a lot for the typical VM. Versus something like 4 or 8.
>>


Hmm, since 32 is the default vcpu number in the old kernel (IIRC), but your suggestion
sounds good.

>> +    /* Both begin and end events did not get the key. */
>> +    if (!event&&  key->key == INVALID_KEY)
>> +        return;
>> +
> Should not be able to get here with event unset, so the next 2 lines should not be needed. ie., you only want to process events where the begin event was seen in which case event is defined.


In some case, the 'begin event' just records the start timestamp, the actually event
is recognised in the 'end event'.

Take mmio-read for example, in the old kernel, we use kvm-exit as the 'begin event'
and kvm_mmio(KVM_TRACE_MMIO_READ...) is the 'end event'.

>> +    "perf kvm events report [<options>]",
> missing '-' between kvm and events
> 


...

>> +static const char * const kvm_events_usage[] = {
>> +    "perf kvm events [<options>] {record|report}",
> missing '-' between kvm and events


Sorry for my careless, these will be fixed in the next version.

Thanks very much for your review, David! :)

