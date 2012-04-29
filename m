Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2D2Nwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2D2Nwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:52:53 -0400
Date: Sun, 29 Apr 2012 16:52:27 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
Message-ID: <20120429135227.GC15413@redhat.com>
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
 <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com>
 <20120424095923.GS15413@redhat.com>
 <4F9D3F8B.9010805@redhat.com>
 <20120429132030.GB15413@redhat.com>
 <4F9D417D.1050105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9D417D.1050105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 04:26:21PM +0300, Avi Kivity wrote:
> On 04/29/2012 04:20 PM, Gleb Natapov wrote:
> > > > This is too similar to kvm_irq_delivery_to_apic(). Why not reuse it. We
> > > > can use one of reserved delivery modes as PV delivery mode. We will
> > > > disallow guest to trigger it through apic interface, so this will not be
> > > > part of ABI and can be changed at will.
> > > >
> > > 
> > > I'm not thrilled about this.  Those delivery modes will eventually
> > > become unreserved.  We can have a kvm_lookup_apic_id() that is shared
> > > among implementations.
> > > 
> > This is only internal implementation. If they become unreserved we will
> > use something else.
> >
> 
> Yeah, I'm thinking of that time.  Why do something temporary and fragile?
> 
Why is it fragile? Just by unreserving the value Intel will not break
KVM. Only when KVM will implement apic feature that unreserves the value
we will have to change internal implementation and use another value,
but this will be done by the same patch that does unreserving. The
unreserving may even never happen. Meanwhile kvm_irq_delivery_to_apic()
will likely be optimized to use hash for unicast delivery and unhalt
hypercall will benefit from it immediately.

--
			Gleb.
