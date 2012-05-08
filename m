Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2EHP2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab2EHP2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:28:47 -0400
Date: Tue, 8 May 2012 18:28:43 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply 5/5] kvm_para: guest side for eoi avoidance
Message-ID: <20120508152843.GE8988@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
 <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com>
 <4FA93B3F.3000906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA93B3F.3000906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 05:26:55PM +0200, Paolo Bonzini wrote:
> Il 23/04/2012 16:04, Michael S. Tsirkin ha scritto:
> > +/* Our own copy of __test_and_clear_bit to make sure
> > + * it is done with a single instruction */
> 
> Is this for microoptimization or correctness?  If the latter, it does
> not ensure anything without a "lock" prefix.
> 
It can't race with other vcpus, only with vmexit on the same vcpu.

> Paolo
> 
> > +static inline int kvm_test_and_clear_bit(int nr, volatile u16* addr)
> > +{
> > +	int oldbit;
> > +
> > +	asm volatile("btr %2,%1\n\t"
> > +		     "sbb %0,%0"
> > +		     : "=r" (oldbit), BITOP_ADDR_CONSTRAINT(*addr) : "Ir" (nr));
> > +	return oldbit;

--
			Gleb.
