Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2F0P00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab2F0P0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:26:23 -0400
Date: Wed, 27 Jun 2012 18:26:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
Message-ID: <20120627152624.GC21393@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050937.23698.68442.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627050937.23698.68442.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:09:46PM -0600, Alex Williamson wrote:
> @@ -71,6 +130,14 @@ irqfd_inject(struct work_struct *work)
>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>  }
>  
> +static void
> +irqfd_inject_level(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> +
> +	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
> +}
> +
>  /*
>   * Race-free decouple logic (ordering is critical)
>   */


Why is it safe to ignore return value here?
needs a comment.
