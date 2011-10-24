Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1JXM15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:27:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37195 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1JXM14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:27:56 -0400
Date: Mon, 24 Oct 2011 17:57:34 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to
 support pv-ticketlock
Message-ID: <20111024122734.GA10634@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
 <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com>
 <4EA53A7D.300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4EA53A7D.300@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11102412-3270-0000-0000-00000123503B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2011-10-24 12:14:21]:

> > +/*
> > + * kvm_pv_wait_for_kick_op : Block until kicked by either a KVM_HC_KICK_CPU
> > + * hypercall or a event like interrupt.
> > + *
> > + * @vcpu : vcpu which is blocking.
> > + */
> > +static void kvm_pv_wait_for_kick_op(struct kvm_vcpu *vcpu)
> > +{

[snip]

> > +}
> 
> This hypercall can be replaced by a HLT instruction, no?

Good point. Assuming yield_on_hlt=1, that would allow the vcpu to be put
to sleep and let other vcpus make progress.

I guess with that change, we can also dropthe need for other hypercall
introduced in this patch (kvm_pv_kick_cpu_op()). Essentially a vcpu sleeping 
because of HLT instruction can be woken up by a IPI issued by vcpu releasing a
lock.

- vatsa

