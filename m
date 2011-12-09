Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1LIK7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:59:22 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40429 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1LIK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:59:20 -0500
Message-ID: <4EE1E9FA.5030307@linux.vnet.ibm.com>
Date: Fri, 09 Dec 2011 16:29:06 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com> <20111207104849.GA24849@amt.cnet> <4EDF5413.1030107@linux.vnet.ibm.com> <20111207123330.GA32212@amt.cnet> <4EDF6049.2030204@redhat.com> <20111207133947.GA1708@amt.cnet> <4EDF7DC5.5010504@redhat.com> <4EDF987B.8040900@linux.vnet.ibm.com> <4EE08606.2060508@redhat.com>
In-Reply-To: <4EE08606.2060508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11120900-5490-0000-0000-0000004E61D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 03:10 PM, Avi Kivity wrote:
> On 12/07/2011 06:46 PM, Raghavendra K T wrote:
>> On 12/07/2011 08:22 PM, Avi Kivity wrote:
>>> On 12/07/2011 03:39 PM, Marcelo Tosatti wrote:
>>>>> Also I think we can keep the kicked flag in vcpu->requests, no need
>>>>> for
>>>>> new storage.
>>>>
>>>> Was going to suggest it but it violates the currently organized
>>>> processing of entries at the beginning of vcpu_enter_guest.
>>>>
>>>> That is, this "kicked" flag is different enough from vcpu->requests
>>>> processing that a separate variable seems worthwhile (even more
>>>> different with convertion to MP_STATE at KVM_GET_MP_STATE).
>>>
>>> IMO, it's similar to KVM_REQ_EVENT (which can also cause mpstate to
>>> change due to apic re-evaluation).
>>>
>>
>> Ok, So what I understand is we have to either :
>> 1. retain current kick flag AS-IS but would have to make it migration
>> friendly. [I still have to get more familiar with migration side]
>> or
>> 2. introduce notion similar to KVM_REQ_PVLOCK_KICK(??) to be part of
>> vcpu->requests.
>>
>> So what would be better? Please let me know.
>>
>
> IMO, KVM_REQ.
>

Ok, 'll continue in this direction. Hmm I think now the race condition 
should be kept in mind, pointed by Marcello.

