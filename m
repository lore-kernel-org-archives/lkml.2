Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1JXLTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:19:49 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60424 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1JXLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:19:47 -0400
Message-ID: <4EA549E7.9090601@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 16:50:07 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support
 pv-ticketlock
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com> <4EA53A7D.300@redhat.com>
In-Reply-To: <4EA53A7D.300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:44 PM, Avi Kivity wrote:
> On 10/23/2011 09:05 PM, Raghavendra K T wrote:
>> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
>> +
>> +end_wait:
>> +	finish_wait(&vcpu->wq,&wait);
>> +}
>
> This hypercall can be replaced by a HLT instruction, no?
>
> I'm pretty sure this misses a lot of stuff from kvm_vcpu_block().

Yes.. agree. HLT sounds better idea. 'll try this out.

>
>> +	if (vcpu) {
>> +		vcpu->kicked = 1;
>
> Need to use smp memory barriers here.

Agree.

>
>> +		wake_up_interruptible(&vcpu->wq);
>> +	}
>> +}
>> +
>>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned long nr, a0, a1, a2, a3, ret;
>>
>

