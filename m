Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1KOOZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:25:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57087 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab1KOOZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:25:30 -0500
Subject: Re: [PATCH] virtio-mmio: Correct the name of the guest features
 selector
From: Pawel Moll <pawel.moll@arm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
In-Reply-To: <1321366638-28408-1-git-send-email-levinsasha928@gmail.com>
References: <1321366638-28408-1-git-send-email-levinsasha928@gmail.com>
Date: Tue, 15 Nov 2011 14:25:22 +0000
Message-ID: <1321367122.3137.142.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 15 Nov 2011 14:25:23.0007 (UTC) FILETIME=[69175CF0:01CCA3A2]
X-MC-Unique: 111111514252701101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 14:17 +0000, Sasha Levin wrote:
> Guest features selector spelling mistake.
>
> diff --git a/include/linux/virtio_mmio.h b/include/linux/virtio_mmio.h
> index 27c7ede..5c7b6f0 100644
> --- a/include/linux/virtio_mmio.h
> +++ b/include/linux/virtio_mmio.h
> @@ -63,7 +63,7 @@
>  #define VIRTIO_MMIO_GUEST_FEATURES	0x020
>  
>  /* Activated features set selector - Write Only */
> -#define VIRTIO_MMIO_GUEST_FEATURES_SET	0x024
> +#define VIRTIO_MMIO_GUEST_FEATURES_SEL	0x024
>  
>  /* Guest's memory page size in bytes - Write Only */
>  #define VIRTIO_MMIO_GUEST_PAGE_SIZE	0x028

Damn. Sorry about it. But if you change the header you'll need to change
the driver:

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 1f25bb9..10bb8b9 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -161,7 +161,7 @@ static void vm_finalize_features(struct virtio_device *vdev)
        vring_transport_features(vdev);
 
        for (i = 0; i < ARRAY_SIZE(vdev->features); i++) {
-               writel(i, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SET);
+               writel(i, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
                writel(vdev->features[i],
                                vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
        }

Cheers!

Paweł


