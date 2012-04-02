Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2DBMQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:16:17 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33164 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2DBMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:16:15 -0400
Message-ID: <4F79985F.5030600@linux.vnet.ibm.com>
Date: Mon, 02 Apr 2012 17:45:27 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Meadows <alan.meadows@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com> <4F743247.5080407@redhat.com> <4F74A405.2040609@linux.vnet.ibm.com> <4F7585EE.7060203@linux.vnet.ibm.com> <4F7855A1.80107@redhat.com> <4F785CC9.7070204@linux.vnet.ibm.com> <4F785DCF.7020809@redhat.com> <4F7976B6.5050000@linux.vnet.ibm.com>
In-Reply-To: <4F7976B6.5050000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12040212-8256-0000-0000-000001DF3362
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 03:21 PM, Raghavendra K T wrote:
> On 04/01/2012 07:23 PM, Avi Kivity wrote:
>  > On 04/01/2012 04:48 PM, Raghavendra K T wrote:
>  >>>> I have patch something like below in mind to try:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5127668..3fa912a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1557,12 +1557,17 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
> mark_page_dirty_in_slot(kvm, memslot, gfn);
> }
>
> +#define YIELD_THRESHOLD 2048
> +static void kvm_vcpu_try_yield_to(struct kvm_vcpu *me);
> /*
> * The vCPU has executed a HLT instruction with in-kernel mode enabled.
> */
> void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> {
[...]
> + if (loop_count++ % YIELD_THRESHOLD)
> + schedule();
> + else
> + kvm_vcpu_try_yield_to(vcpu);
> }
>
> +static void kvm_vcpu_try_yield(struct kvm_vcpu *me)

yes, it is kvm_vcpu_try_yield_to. had changed the name just before
sending. sorry.

