Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2F1Ifs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2F1Ifp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:35:45 -0400
Date: Thu, 28 Jun 2012 11:35:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
Message-ID: <20120628083541.GN6533@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050937.23698.68442.stgit@bling.home>
 <20120627152624.GC21393@redhat.com>
 <1340834658.1207.261.camel@bling.home>
 <20120627223128.GB27885@redhat.com>
 <20120628063431.GI6533@redhat.com>
 <20120628083435.GC12447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628083435.GC12447@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 11:34:35AM +0300, Michael S. Tsirkin wrote:
> On Thu, Jun 28, 2012 at 09:34:31AM +0300, Gleb Natapov wrote:
> > On Thu, Jun 28, 2012 at 01:31:29AM +0300, Michael S. Tsirkin wrote:
> > > On Wed, Jun 27, 2012 at 04:04:18PM -0600, Alex Williamson wrote:
> > > > On Wed, 2012-06-27 at 18:26 +0300, Michael S. Tsirkin wrote:
> > > > > On Tue, Jun 26, 2012 at 11:09:46PM -0600, Alex Williamson wrote:
> > > > > > @@ -71,6 +130,14 @@ irqfd_inject(struct work_struct *work)
> > > > > >  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > > > > >  }
> > > > > >  
> > > > > > +static void
> > > > > > +irqfd_inject_level(struct work_struct *work)
> > > > > > +{
> > > > > > +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> > > > > > +
> > > > > > +	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
> > > > > > +}
> > > > > > +
> > > > > >  /*
> > > > > >   * Race-free decouple logic (ordering is critical)
> > > > > >   */
> > > > > 
> > > > > 
> > > > > Why is it safe to ignore return value here?
> > > > > needs a comment.
> > > > 
> > > > Well, it seems like you and Gleb came to the conclusion that it's safe,
> > > > but I can really follow from the list thread.  Can you explain and I'll
> > > > add a comment?  Thanks,
> > > > 
> > > > Alex
> > > 
> > > We merely talked about edge interrupts.
> > > 
> > In fact it would have been nice to return -EBUSY when write() to level
> > irqfd is coalesced.
> 
> Possibly nice but not really practical.
> 
What do you mean by that? Impossible to implement or not useful?

--
			Gleb.
