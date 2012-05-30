Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2E3OCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:02:37 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49780 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2E3OCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:02:35 -0400
Message-ID: <4FC62458.7030802@linux.vnet.ibm.com>
Date: Wed, 30 May 2012 19:14:56 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen Devel <xen-devel@lists.xensource.com>, KVM <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH RFC V8 17/17] Documentation/kvm : Add documentation on
 Hypercalls and features used for PV spinlock
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120502100947.13206.26518.sendpatchset@codeblue.in.ibm.com> <4FC60A71.5050804@siemens.com>
In-Reply-To: <4FC60A71.5050804@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12053013-5564-0000-0000-00000301847F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 05:24 PM, Jan Kiszka wrote:
> On 2012-05-02 12:09, Raghavendra K T wrote:
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>
>> KVM_HC_KICK_CPU  hypercall added to wakeup halted vcpu in paravirtual spinlock
>> enabled guest.
>>
>> KVM_FEATURE_PV_UNHALT enables guest to check whether pv spinlock can be enabled
>> in guest.
>>
>> Thanks Alex for KVM_HC_FEATURES inputs and Vatsa for rewriting KVM_HC_KICK_CPU
>
> This contains valuable documentation for features that are already
> supported. Can you break them out and post as separate patch already?
> One comment on them below.
>

That sounds like a good idea. Sure, will do that.

>>
>> Signed-off-by: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   Documentation/virtual/kvm/cpuid.txt      |    4 ++
>>   Documentation/virtual/kvm/hypercalls.txt |   60 ++++++++++++++++++++++++++++++
>>   2 files changed, 64 insertions(+), 0 deletions(-)
>> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
>> index 8820685..062dff9 100644
>> --- a/Documentation/virtual/kvm/cpuid.txt
>> +++ b/Documentation/virtual/kvm/cpuid.txt
>> @@ -39,6 +39,10 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
>>   KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
>>                                      ||       || writing to msr 0x4b564d02
>>   ------------------------------------------------------------------------------
>> +KVM_FEATURE_PV_UNHALT              ||     6 || guest checks this feature bit
>> +                                   ||       || before enabling paravirtualized
>> +                                   ||       || spinlock support.
>> +------------------------------------------------------------------------------
>>   KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
>>                                      ||       || per-cpu warps are expected in
>>                                      ||       || kvmclock.
>> diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
>> new file mode 100644
>> index 0000000..bc3f14a
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/hypercalls.txt
>> @@ -0,0 +1,60 @@
>> +KVM Hypercalls Documentation
>> +===========================
>> +The template for each hypercall is:
>> +1. Hypercall name, value.
>> +2. Architecture(s)
>> +3. Status (deprecated, obsolete, active)
>> +4. Purpose
>> +
>> +1. KVM_HC_VAPIC_POLL_IRQ
>> +------------------------
>> +Value: 1
>> +Architecture: x86
>> +Purpose: None
>
> Purpose: Trigger guest exit so that the host can check for pending
> interrupts on reentry.

will add fold this and resend.

[...]

