Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2GKNGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:06:41 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44073 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab2GKNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:06:38 -0400
Message-ID: <4FFD79E2.3080307@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 18:34:34 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com> <4FFD52CD.7040403@de.ibm.com> <4FFD68AA.1000607@linux.vnet.ibm.com>
In-Reply-To: <4FFD68AA.1000607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071102-9264-0000-0000-000001E4824B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 05:21 PM, Raghavendra K T wrote:
> On 07/11/2012 03:47 PM, Christian Borntraeger wrote:
>> On 11/07/12 11:06, Avi Kivity wrote:
[...]
>>>> So there is no win here, but there are other cases were diag44 is
>>>> used, e.g. cpu_relax.
>>>> I have to double check with others, if these cases are critical, but
>>>> for now, it seems
>>>> that your dummy implementation for s390 is just fine. After all it
>>>> is a no-op until
>>>> we implement something.
>>>
>>> Does the data structure make sense for you? If so we can move it to
>>> common code (and manage it in kvm_vcpu_on_spin()). We can guard it with
>>> CONFIG_KVM_HAVE_CPU_RELAX_INTERCEPT or something, so other archs don't
>>> have to pay anything.
>>
>> Ignoring the name, yes the data structure itself seems based on the
>> algorithm
>> and not on arch specific things. That should work.
>
> Ok. can you please elaborate, on the flow.
>

Ok got it..  Will check how the code can be common to both x86 and s390.

