Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2GAI0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 04:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab2GAI0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 04:26:25 -0400
Date: Sun, 1 Jul 2012 11:26:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, cornelia.huck@de.ibm.com
Subject: Re: [PATCH v3 3/3] kvm: Sanitize KVM_IRQFD flags
Message-ID: <20120701082634.GB3906@redhat.com>
References: <20120629154940.30535.17132.stgit@bling.home>
 <20120629155622.30535.24831.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629155622.30535.24831.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 09:56:24AM -0600, Alex Williamson wrote:
> We only know of one so far.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

BTW should we sanitize padding as well?

> ---
> 
>  virt/kvm/eventfd.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c307c24..7d7e2aa 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -340,6 +340,9 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  int
>  kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
>  {
> +	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
> +		return -EINVAL;
> +
>  	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
>  		return kvm_irqfd_deassign(kvm, args);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
