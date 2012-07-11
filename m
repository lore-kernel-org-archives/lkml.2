Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2GKDD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:03:26 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46318 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2GKDDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:03:24 -0400
Message-ID: <4FFCEC62.5090200@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 08:30:50 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V2 2/2] kvm PLE handler: Choose better candidate for
 directed yield
References: <20120710193056.16440.40112.sendpatchset@codeblue> <20120710193138.16440.31791.sendpatchset@codeblue> <20120710205018.GB16986@gmail.com>
In-Reply-To: <20120710205018.GB16986@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071016-7014-0000-0000-00000189FA43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:20 AM, Ingo Molnar wrote:
>
> * Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>  wrote:
>
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1595,6 +1595,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>   				continue;
>>   			if (waitqueue_active(&vcpu->wq))
>>   				continue;
>> +			if (!kvm_arch_vcpu_check_and_update_eligible(vcpu)) {
>> +				continue;
>> +			}
>
> Saw this fly by for a second time and now it annoyed me enough
> to mention it: those curly braces are superfluous and should be
> dropped.
>

Oops! Sorry.will remove {} and resend with Rik's reviewed-by. TBH,
block got simplified after iterations (local), this one leftout. my
mistake.

