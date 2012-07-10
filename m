Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2GJUu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:50:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59241 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GJUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:50:24 -0400
Date: Tue, 10 Jul 2012 22:50:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V2 2/2] kvm PLE handler: Choose better candidate for
 directed yield
Message-ID: <20120710205018.GB16986@gmail.com>
References: <20120710193056.16440.40112.sendpatchset@codeblue>
 <20120710193138.16440.31791.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710193138.16440.31791.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1595,6 +1595,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  				continue;
>  			if (waitqueue_active(&vcpu->wq))
>  				continue;
> +			if (!kvm_arch_vcpu_check_and_update_eligible(vcpu)) {
> +				continue;
> +			}

Saw this fly by for a second time and now it annoyed me enough 
to mention it: those curly braces are superfluous and should be 
dropped.

Thanks,

	Ingo
