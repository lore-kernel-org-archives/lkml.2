Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2GJLsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:48:47 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40306 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2GJLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:48:43 -0400
Message-ID: <4FFC1610.5060801@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 17:16:24 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 2/2] kvm PLE handler: Choose better candidate for
 directed yield
References: <20120709062012.24030.37154.sendpatchset@codeblue> <20120709062053.24030.52767.sendpatchset@codeblue> <4FFB5B81.4040903@redhat.com>
In-Reply-To: <4FFB5B81.4040903@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071001-5490-0000-0000-000001C19605
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 04:00 AM, Rik van Riel wrote:
> On 07/09/2012 02:20 AM, Raghavendra K T wrote:
>
>> +bool kvm_arch_vcpu_check_and_update_eligible(struct kvm_vcpu *vcpu)
>> +{
>> + bool eligible;
>> +
>> + eligible = !vcpu->arch.plo.pause_loop_exited ||
>> + (vcpu->arch.plo.pause_loop_exited&&
>> + vcpu->arch.plo.dy_eligible);
>> +
>> + if (vcpu->arch.plo.pause_loop_exited)
>> + vcpu->arch.plo.dy_eligible = !vcpu->arch.plo.dy_eligible;
>> +
>> + return eligible;
>> +}
>
> This is a nice simple mechanism to skip CPUs that were
> eligible last time and had pause loop exits recently.
>
> However, it could stand some documentation. Please
> add a good comment explaining how and why the algorithm
> works, when arch.plo.pause_loop_exited is cleared, etc...
>
> It would be good to make this heuristic understandable
> to people who look at the code for the first time.
>

Thanks for the review. will do more documentation.

