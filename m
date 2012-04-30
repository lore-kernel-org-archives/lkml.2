Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2D3HqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:46:13 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42507 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab2D3HqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:46:10 -0400
Message-ID: <4F9E4328.6060000@linux.vnet.ibm.com>
Date: Mon, 30 Apr 2012 13:15:44 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH RFC V6 2/5] kvm : Fold pv_unhalt flag into GET_MP_STATE
 ioctl to aid migration
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423100002.30893.60584.sendpatchset@codeblue.in.ibm.com> <4F9D41DE.3080100@redhat.com>
In-Reply-To: <4F9D41DE.3080100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12043007-5564-0000-0000-00000267ED60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 06:57 PM, Avi Kivity wrote:
> On 04/23/2012 01:00 PM, Raghavendra K T wrote:
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6faa550..7354c1b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5691,7 +5691,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>>   int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>>   				    struct kvm_mp_state *mp_state)
>>   {
>> -	mp_state->mp_state = vcpu->arch.mp_state;
>> +	mp_state->mp_state = (vcpu->arch.mp_state == KVM_MP_STATE_HALTED&&
>> +				vcpu->arch.pv.pv_unhalted) ?
>> +	KVM_MP_STATE_RUNNABLE : vcpu->arch.mp_state;
>>   	return 0;
>>   }
>
> Not pretty.  Suggest rewriting using an if.
>

Ok.. 'll rewrite.

