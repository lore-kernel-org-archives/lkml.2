Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2GIWbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2GIWbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:31:12 -0400
Message-ID: <4FFB5B81.4040903@redhat.com>
Date: Mon, 09 Jul 2012 18:30:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
References: <20120709062012.24030.37154.sendpatchset@codeblue> <20120709062053.24030.52767.sendpatchset@codeblue>
In-Reply-To: <20120709062053.24030.52767.sendpatchset@codeblue>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 02:20 AM, Raghavendra K T wrote:

> +bool kvm_arch_vcpu_check_and_update_eligible(struct kvm_vcpu *vcpu)
> +{
> +	bool eligible;
> +
> +	eligible = !vcpu->arch.plo.pause_loop_exited ||
> +			(vcpu->arch.plo.pause_loop_exited&&
> +			 vcpu->arch.plo.dy_eligible);
> +
> +	if (vcpu->arch.plo.pause_loop_exited)
> +		vcpu->arch.plo.dy_eligible = !vcpu->arch.plo.dy_eligible;
> +
> +	return eligible;
> +}

This is a nice simple mechanism to skip CPUs that were
eligible last time and had pause loop exits recently.

However, it could stand some documentation.  Please
add a good comment explaining how and why the algorithm
works, when arch.plo.pause_loop_exited is cleared, etc...

It would be good to make this heuristic understandable
to people who look at the code for the first time.

-- 
All rights reversed
