Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2BIDHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:07:46 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44924 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2BIDHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:07:45 -0500
Message-ID: <4F333877.8050508@linux.vnet.ibm.com>
Date: Thu, 09 Feb 2012 11:07:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: perf: kvm events analysis tool
References: <4F3121DE.7020502@linux.vnet.ibm.com> <4F31225C.1020703@gmail.com> <4F316596.3060509@gmail.com> <4F3212CA.4080208@linux.vnet.ibm.com> <4F32861C.5020907@gmail.com>
In-Reply-To: <4F32861C.5020907@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020903-9574-0000-0000-0000014CE3DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 10:26 PM, David Ahern wrote:


>>>> +static int kvm_events_report(int vcpu)
>>>> +{
>>>> +	init_kvm_event_record();
>>>> +	init_kvm_tid_to_pid();
>>>> +	verify_vcpu(vcpu);
>>>> +	select_key();
>>>> +	register_kvm_events_ops();
>>>> +	setup_pager();
>>>
>>> I believe setup_pager is handled by perf.c
>>>
>>
>>
>> Hmm, i did not find it, could you please tell me where is it?
>> And, setup_pager is also used in other tools such 'perf sched',
>> 'perf lock'...
>>
> 
> run_builtin() --> commit_pager_choice() --> setup_pager()
> 
> It could be that the other commands need to be updated.
> 


David,

Thanks for your review and explanation!

The code of commit_pager_choice():
static void commit_pager_choice(void)
{
	switch (use_pager) {
	case 0:
		setenv("PERF_PAGER", "cat", 1);
		break;
	case 1:
		/* setup_pager(); */
		break;
	default:
		break;
	}
}

setup_pager() is not called.

And it looks like kvm-events can not show the result properly if
i try to remove setup_pager.


