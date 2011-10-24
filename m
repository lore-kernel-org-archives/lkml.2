Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1JXLAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:00:30 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46071 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1JXLA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:00:28 -0400
Message-ID: <4EA5455E.5090007@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 16:30:46 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
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
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support
 pv-ticketlock
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com> <1319450510.5660.6.camel@lappy>
In-Reply-To: <1319450510.5660.6.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11102411-2000-0000-0000-000000A9D0A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:31 PM, Sasha Levin wrote:
> On Mon, 2011-10-24 at 00:35 +0530, Raghavendra K T wrote:
>> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
>>
>> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
>> +{
>> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
>> +
>> +	if (vcpu) {
>> +		vcpu->kicked = 1;
>
> I'm not sure about it, but maybe we want a memory barrier over here?

Yes, Thanks for pointing this. Avi Kivity also pointed same. 'll add 
barrier() here.

>
>> +		wake_up_interruptible(&vcpu->wq);
>> +	}
>> +}

