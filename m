Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab1KPCdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:33:11 -0500
Received: from ozlabs.org ([203.10.76.45]:41446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab1KPCdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-mmio: Correct the name of the guest features selector
In-Reply-To: <1321367122.3137.142.camel@hornet.cambridge.arm.com>
References: <1321366638-28408-1-git-send-email-levinsasha928@gmail.com> <1321367122.3137.142.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 16 Nov 2011 11:15:14 +1030
Message-ID: <87pqgsopyd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 14:25:22 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Tue, 2011-11-15 at 14:17 +0000, Sasha Levin wrote:
> > Guest features selector spelling mistake.
> >
> > diff --git a/include/linux/virtio_mmio.h b/include/linux/virtio_mmio.h
> > index 27c7ede..5c7b6f0 100644
> > --- a/include/linux/virtio_mmio.h
> > +++ b/include/linux/virtio_mmio.h
> > @@ -63,7 +63,7 @@
> >  #define VIRTIO_MMIO_GUEST_FEATURES	0x020
> >  
> >  /* Activated features set selector - Write Only */
> > -#define VIRTIO_MMIO_GUEST_FEATURES_SET	0x024
> > +#define VIRTIO_MMIO_GUEST_FEATURES_SEL	0x024
> >  
> >  /* Guest's memory page size in bytes - Write Only */
> >  #define VIRTIO_MMIO_GUEST_PAGE_SIZE	0x028
> 
> Damn. Sorry about it. But if you change the header you'll need to change
> the driver:
> 
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 1f25bb9..10bb8b9 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -161,7 +161,7 @@ static void vm_finalize_features(struct virtio_device *vdev)
>         vring_transport_features(vdev);
>  
>         for (i = 0; i < ARRAY_SIZE(vdev->features); i++) {
> -               writel(i, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SET);
> +               writel(i, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
>                 writel(vdev->features[i],
>                                 vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
>         }

Rolled together and applied.

Thanks,
Rusty.
