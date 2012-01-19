Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2ASQjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:39:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2ASQjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:39:21 -0500
Date: Thu, 19 Jan 2012 18:39:17 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, jan.kiszka@siemens.com,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: deliver msix interrupts from irq handler
Message-ID: <20120119163917.GB18770@redhat.com>
References: <20120118181023.GA4140@redhat.com>
 <20120119072123.GE9571@redhat.com>
 <20120119134957.GC4009@redhat.com>
 <20120119150217.GA20920@redhat.com>
 <20120119155748.GA6340@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119155748.GA6340@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 05:57:48PM +0200, Michael S. Tsirkin wrote:
> On Thu, Jan 19, 2012 at 05:02:17PM +0200, Gleb Natapov wrote:
> > On Thu, Jan 19, 2012 at 03:49:57PM +0200, Michael S. Tsirkin wrote:
> > > > > +	irq_rt = rcu_dereference(kvm->irq_routing);
> > > > > +	if (irq < irq_rt->nr_rt_entries)
> > > > > +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
> > > > > +			if (ei->type == KVM_IRQ_ROUTING_MSI)
> > > > > +				ret = kvm_set_msi(e, kvm, irq_source_id, level,
> > > > > +						  host_irq);
> > > > > +			else
> > > > > +				ret = -EWOULDBLOCK;
> > > > > +			break;
> > > > > +		}
> > > > > +	rcu_read_unlock_bh();
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > Share implementation with kvm_set_irq().
> > > 
> > > I considered this. There are several reasons not to do it:
> > > - Amount of common code is very small
> > Why? Just pass msi_only flag to kvm_set_irq() and skip an entry if flag is
> > set and entry type is not msi.
> > 
> > > - As it's separate, it's more obvious that it can't block (kvm_set_irq can block)
> > >   We can even tag kvm_set_irq with might_sleep.
> > They can still be two separate function calling common one.
> 
> No, the common code is the surrounding foreach loop,
> the internal if branch is different.
> 
I do not see any complication whatsoever. The reuse it trivial.

--
			Gleb.
