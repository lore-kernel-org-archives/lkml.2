Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab2GPHk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:40:29 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45926 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2GPHk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:40:26 -0400
Message-ID: <5003C4E5.8000606@linux.vnet.ibm.com>
Date: Mon, 16 Jul 2012 13:08:13 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V3 2/3] kvm: Note down when cpu relax intercepted
 or pause loop exited
References: <20120712191712.30440.68944.sendpatchset@codeblue> <20120712191800.30440.16406.sendpatchset@codeblue> <4FFF2D5F.3050902@de.ibm.com> <20120713135426.GA5208@linux.vnet.ibm.com>
In-Reply-To: <20120713135426.GA5208@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071521-7014-0000-0000-000001904BC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 07:24 PM, Srikar Dronamraju wrote:
>> On 12/07/12 21:18, Raghavendra K T wrote:
>>> +#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>> [...]
>>> +	struct {
>>> +		bool cpu_relax_intercepted;
>>> +		bool dy_eligible;
>>> +	} ple;
>>> +#endif
>> [...]
>>>   	}
>>>   	vcpu->run = page_address(page);
>>> +	vcpu->ple.cpu_relax_intercepted = false;
>>> +	vcpu->ple.dy_eligible = false;
>>
>> This struct is only defined if CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT is set, but here it
>> is always accessed. Will break on !x86&&  !s390.
>
> How about moving this struct definition outside the CONFIG.
> i.e it would be available by default.
> If any arch cares to use vcpu_on_spin(), they would get the benefit by
> default.
>
> This would avoid all the CONFIG magic that we would have to do
> otherwise.
>

Okay, after discussing with Christian,
- even if ppc uses vcpu_on spin we will still be left with ia64 (though
broken currently) and arm (is on way).
- those who want to opt-out of this optimization but still wish to use
vcpu_spin, we have flexibility.

So with that in mind I am spinning V4 with
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT. Let us see how it goes.

