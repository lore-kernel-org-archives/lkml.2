Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2GROlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:41:44 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36305 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2GROlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:41:40 -0400
Message-ID: <5006CA88.8040906@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 20:09:04 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V5 3/3] kvm: Choose better candidate for directed
 yield
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com> <20120718133800.5321.51446.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120718133800.5321.51446.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071805-3568-0000-0000-000002272716
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 07:08 PM, Raghavendra K T wrote:
> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
> +bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
> +{
> +	bool eligible;
> +
> +	eligible = !vcpu->spin_loop.in_spin_loop ||
> +			(vcpu->spin_loop.in_spin_loop&&
> +			 vcpu->spin_loop.dy_eligible);
> +
> +	if (vcpu->spin_loop.in_spin_loop)
> +		vcpu->spin_loop.dy_eligible = !vcpu->spin_loop.dy_eligible;
> +
> +	return eligible;
> +}

I should have added a comment like:
Since algorithm is based on heuristics, accessing another vcpu data
without locking does not harm. It may result in trying to yield to  same 
VCPU, fail and continue with next and so on.

