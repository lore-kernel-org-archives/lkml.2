Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2GBPtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2GBPto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:49:44 -0400
Message-ID: <1341244179.1207.447.camel@bling.home>
Subject: Re: [PATCH v3 3/3] kvm: Sanitize KVM_IRQFD flags
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, cornelia.huck@de.ibm.com
Date: Mon, 02 Jul 2012 09:49:39 -0600
In-Reply-To: <20120701082634.GB3906@redhat.com>
References: <20120629154940.30535.17132.stgit@bling.home>
	 <20120629155622.30535.24831.stgit@bling.home>
	 <20120701082634.GB3906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-01 at 11:26 +0300, Michael S. Tsirkin wrote:
> On Fri, Jun 29, 2012 at 09:56:24AM -0600, Alex Williamson wrote:
> > We only know of one so far.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> BTW should we sanitize padding as well?

I imagine that to make use of a field in the padding we'll set a bit in
the flags to indicate that the field is present/valid.  That way we
don't care about garbage in the padding as long as we can sanitize the
flags.  Thanks,

Alex

> > ---
> > 
> >  virt/kvm/eventfd.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index c307c24..7d7e2aa 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -340,6 +340,9 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
> >  int
> >  kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
> >  {
> > +	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
> > +		return -EINVAL;
> > +
> >  	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
> >  		return kvm_irqfd_deassign(kvm, args);
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/



