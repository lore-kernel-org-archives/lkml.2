Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2FXPti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:49:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2FXPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:49:37 -0400
Date: Sun, 24 Jun 2012 18:49:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH 3/4] kvm: Extend irqfd to support level interrupts
Message-ID: <20120624154938.GE2851@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
 <20120622221559.9858.59593.stgit@bling.home>
 <4FE6EC20.5030502@redhat.com>
 <1340551118.14120.66.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340551118.14120.66.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 09:18:38AM -0600, Alex Williamson wrote:
> > > @@ -242,7 +299,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> > >  
> > >  	ret = 0;
> > >  	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> > > -		if (irqfd->eventfd != tmp->eventfd)
> > > +		if (irqfd->eventfd != tmp->eventfd &&
> > > +		    irqfd->eventfd != tmp->eoi_eventfd)
> > >  			continue;
> > 
> > So we allow duplicate irqfd with differing eoifd (or edge-triggered and
> > level-triggered irqfd on the same context).
> > 
> > (why the check in the first place? just so we can have a reliable
> > deassign or is it avoiding a deeper problem?)
> 
> I really wasn't sure to what extent we wanted to prevent duplicates.  My
> guess was that we don't want to have an irqfd trigger more than one
> thing.  That seems to be what the current code does.  I don't see any
> problems with multiple irqfds triggering the same eventfd though.  I
> only added a test that a new irqfd can't be triggered by an existing
> eoi_eventfd as that could make a nasty loop.

How would that make a loop? You can have the same thing
with e.g. ioeventfd - why isn't it a problem there?

-- 
MST
