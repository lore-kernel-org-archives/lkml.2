Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2HVBsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 21:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab2HVBsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 21:48:15 -0400
Message-ID: <1345600094.29292.125.camel@ul30vt.home>
Subject: Re: [PATCH v9 2/2] kvm: On Ack, De-assert & Notify KVM_IRQFD
 extension
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2012 19:48:14 -0600
In-Reply-To: <20120822001451.GJ9027@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
	 <20120821192911.24958.38609.stgit@bling.home>
	 <20120821203739.GE9027@redhat.com> <1345583501.29292.89.camel@ul30vt.home>
	 <20120822001451.GJ9027@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 03:14 +0300, Michael S. Tsirkin wrote:
> On Tue, Aug 21, 2012 at 03:11:41PM -0600, Alex Williamson wrote:
> > On Tue, 2012-08-21 at 23:37 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Aug 21, 2012 at 01:29:14PM -0600, Alex Williamson wrote:
> > > > +	}
> > > > +
> > > >  	irq_rt = rcu_dereference_protected(kvm->irq_routing,
> > > >  					   lockdep_is_held(&kvm->irqfds.lock));
> > > >  	irqfd_update(kvm, irqfd, irq_rt);
> > > > @@ -267,6 +426,26 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> > > >  
> > > >  	spin_unlock_irq(&kvm->irqfds.lock);
> > > >  
> > > > +	if (oadn) {
> > > > +		synchronize_rcu();
> > > 
> > > Seems unexpected on assign.
> > > What does this synchronize_rcu do?
> > 
> > Because we force the notify below and we need the irqfd we just added to
> > the list to be visible on the list for that.
> 
> I do not see it yet - maybe add a comment?

It's entirely possible I'm wrong too.  This was an after thought and now
that I look at it again, the below irqfd_oadn_notify obviously starts
after the list_add, so there shouldn't be any need to wait.  Thanks,

Alex

