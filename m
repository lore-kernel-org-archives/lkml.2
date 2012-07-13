Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818Ab2GMGNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:13:54 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:45139 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201Ab2GMGNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:13:51 -0400
Message-ID: <4FFFBC9A.6080107@de.ibm.com>
Date: Fri, 13 Jul 2012 08:13:46 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
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
References: <20120712191712.30440.68944.sendpatchset@codeblue> <20120712191800.30440.16406.sendpatchset@codeblue> <4FFF2D5F.3050902@de.ibm.com> <4FFF979F.8070100@linux.vnet.ibm.com>
In-Reply-To: <4FFF979F.8070100@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071306-1948-0000-0000-00000261712E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/12 05:35, Raghavendra K T wrote:
> Yes! I forgot about archs in init function.
> How about having
> #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> vcpu->ple.cpu_relax_intercepted = false;
> vcpu->ple.dy_eligible = false;
> #endif
> 
> This would solve all the problem.

No, you need to mask all places....

> 
>>>
>>>       r = kvm_arch_vcpu_init(vcpu);
>>>       if (r<  0)
>>> @@ -1577,6 +1579,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>>       int pass;
>>>       int i;
>>>
>>> +    me->ple.cpu_relax_intercepted = true;
>>
>> dito
> 
> currently vcpu_on_spin is used only by x86 and s390. so if some other
> arch in future uses vcpu_on_spin, I believe they also have to enable
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> what do you think?

...because  this function is compiled no matter if called or not.
> 
>> maybe define static inline access functions in kvm_host.h that are no-ops
>> if CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT is not set.

As I already said, can you have a look at using access functions?




