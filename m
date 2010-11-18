Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0KRNS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:18:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0KRNSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:18:54 -0500
Message-ID: <4CE527B7.4060006@redhat.com>
Date: Thu, 18 Nov 2010 15:18:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
References: <20101117221254.GA8296@redhat.com> <20101118105741.GA31261@redhat.com> <4CE50810.3090502@redhat.com> <20101118111037.GB31261@redhat.com> <4CE51C17.4000108@redhat.com> <20101118130337.GA2254@redhat.com> <20101118131453.GO7948@redhat.com>
In-Reply-To: <20101118131453.GO7948@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 03:14 PM, Gleb Natapov wrote:
> On Thu, Nov 18, 2010 at 03:03:37PM +0200, Michael S. Tsirkin wrote:
> >  >  >+static inline void kvm_irq_routing_update(struct kvm *kvm,
> >  >  >+					  struct kvm_irq_routing_table *irq_rt)
> >  >  >+{
> >  >  >+	rcu_assign_pointer(kvm->irq_routing, irq_rt);
> >  >  >+}
> >  >  >+
> >  >  >   static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> >  >  >   {
> >  >  >   	return -ENOSYS;
> >  >
> >  >  Apart from these minor issues, looks good.
> >
> >
> >  Something we should consider improving is the loop over all VCPUs that
> >  kvm_irq_delivery_to_apic invokes.  I think that (for non-broadcast
> >  interrupts) it should be possible to precompute an store the CPU
> >  in question as part of the routing entry.
> >
> >  Something for a separate patch ... comments?
> >
> I do not think this info should be part of routing entry. Routing entry
> is more about describing wires on the board. Other then that
> this is a good idea that, IIRC, we already discussed once.
>

Not as part of the routing entry exposed to userspace.  But as a private 
kernel field, why not?

-- 
error compiling committee.c: too many arguments to function

