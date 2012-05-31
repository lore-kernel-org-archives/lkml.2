Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2EaOwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:52:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2EaOwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:52:32 -0400
Date: Thu, 31 May 2012 17:52:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 5/5] kvm: host side for eoi optimization
Message-ID: <20120531145219.GA20290@redhat.com>
References: <cover.1337695416.git.mst@redhat.com>
 <f434b6864a1af1f813e6ead964026553cd879c38.1337695416.git.mst@redhat.com>
 <20120531095710.GM2311@redhat.com>
 <20120531101111.GA15836@redhat.com>
 <20120531101513.GO2311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531101513.GO2311@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 01:15:13PM +0300, Gleb Natapov wrote:
> > > > +	    /* Cache not set: safe but we don't bother. */
> > > > +	    unlikely(apic->isr_cache == -1) ||
> > > > +	    /* Need EOI to update ioapic. */
> > > > +	    unlikely(kvm_ioapic_handles_vector(vcpu->kvm, apic->isr_cache)))
> > > > +		return;
> > > > +
> > > > +	pv_eoi_set_pending(apic->vcpu);
> > > > +}
> > > > +
> > > apic_sync_pv_eoi_to_guest() is not paired with
> > > apic_sync_pv_eoi_from_guest() if event injection is canceled.
> > > You can enter guest with stale pv_eoi bit.
> > 
> > Never. The pv_eoi bit is cleared on each exit.
> There will be no exit since there will be no entry. Search for
> "goto out" after kvm_lapic_sync_to_vapic().

I think you've found a bug, thanks a bunch.
I have fixed it but the x86 guys asked me not to
post more patches until merge window closes :(
So I'll sit on a fix for several days.
