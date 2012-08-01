Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2HAKvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:51:42 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36936 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2HAKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:51:39 -0400
Message-ID: <5019099D.9050608@linux.vnet.ibm.com>
Date: Wed, 01 Aug 2012 16:19:01 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120724085359.11344.91022.sendpatchset@codeblue.in.ibm.com> <20120801030736.GA31711@amt.cnet>
In-Reply-To: <20120801030736.GA31711@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12080110-9264-0000-0000-000002099958
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 08:37 AM, Marcelo Tosatti wrote:
> On Tue, Jul 24, 2012 at 02:23:59PM +0530, Raghavendra K T wrote:
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>
>> Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ,
>> and Peter (HPA) for suggesting hypercall ABI addition.
>>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> Please have a closer look at Hypercall ABI newly added
>>
>> Changes since last post:
>>   - Added hypercall ABI (Peter)
>>   - made KVM_HC_VAPIC_POLL_IRQ active explicitly (Randy)
>>
>> TODO: We need to add history details of each hypercall as suggested by HPA,
>> which I could not trace easily. Hope it is easy for hypercall authors
>>
>>   Documentation/virtual/hypercalls.txt |   71 ++++++++++++++++++++++++++++++++++
>>   1 files changed, 71 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/virtual/hypercalls.txt
>>
>> diff --git a/Documentation/virtual/hypercalls.txt b/Documentation/virtual/hypercalls.txt
>> new file mode 100644
>> index 0000000..caffc08
>> --- /dev/null
>> +++ b/Documentation/virtual/hypercalls.txt
>> @@ -0,0 +1,71 @@
>> +Hypercall ABI:
>> +=============
>> +A brief look at calling conventions of X86, S390 and PPC
>> +X86:
>> + KVM Hypercalls have a three-byte sequence of either the vmrun or the vmmrun
>> + instruction. The hypervisor can replace it with instructions that are
>> + guaranteed to be supported.
>
> vmcall.

How is this:
  KVM Hypercalls have a three-byte sequence of vmcall instruction. But
The hypervisor can replace it with the instructions that are guaranteed
to be supported.

(Related question: Is it not that vmcall instruction is patched by 0f
01 09 vmmcall instruction sequence for amd?. So I think we need to
change documentation I referred from arch/x86/include/asm/kvm_para.h.
It should be vmcall / vmmcall instead of vmrun and vmmrun)

>
>> +
>> + Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
>> + The hypercall number should be placed in rax and the return value will be
>> + placed in rax.  No other registers will be clobbered unless explicitly stated
>> + by the particular hypercall.
>
> It depends on the hypercall. It happens that current hypercalls use
> the four registers, but its not an ABI (hyper-v hypercalls uses r8, for example).
>

Okay, agree. I did not know about hyper-v. Above one is for X86 and
KVM  (and not X86 / hyper-v). So I should remove ABI and probably say,

KVM x86 Hypercall
==================
Up to four arguments may be passed in rbx, rcx, rdx, and rsi
respectively. The hypercall number should be placed in rax and the
return value will be placed in rax.  No other registers will be
clobbered unless explicitly stated by the particular hypercall.

