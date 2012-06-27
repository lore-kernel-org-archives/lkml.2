Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2F0KDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2F0KDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:03:47 -0400
Date: Wed, 27 Jun 2012 13:03:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm: don't clear level from irqfd
Message-ID: <20120627100345.GA6533@redhat.com>
References: <20120627091343.GA17693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627091343.GA17693@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:13:43PM +0300, Michael S. Tsirkin wrote:
> irqfd sets and clears the level immediately.
> This used to be necessary for MSI interrupts but isn't anymore.
> 
> Note! We never officially supported irqfd for level
> interrupts but it usually seemed to kind of work,
> and this change will break it. There are no known
> real users of that feature though - only old vfio prototypes.
> Removing this line will make it easier to add
> real support for level irqfds in the future.
> 
Did we officially supported irqfd for ioapic/pic edge interrupts?
Because those will break to.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  virt/kvm/eventfd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index f59c1e8..4db6b01 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -68,7 +68,6 @@ irqfd_inject(struct work_struct *work)
>  	struct kvm *kvm = irqfd->kvm;
>  
>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>  }
>  
>  /*
> -- 
> MST

--
			Gleb.
