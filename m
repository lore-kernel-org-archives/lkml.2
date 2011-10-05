Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178Ab1JEJ04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:26:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab1JEJ0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:26:54 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.135.251]
In-Reply-To: <1316948337-7924-2-git-send-email-ohad@wizery.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <1316948337-7924-2-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 5 Oct 2011 11:26:32 +0200
Message-ID: <CAK=Wgba6xxD2DBJhM--AcTPBoNRiOZ_6f8+j3bfaCqZMO8A4+w@mail.gmail.com>
Subject: Re: [RFC 1/5] ARM: dev_archdata: add private iommu extension
To: Russell King <linux@arm.linux.org.uk>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sun, Sep 25, 2011 at 1:58 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Add a private iommu pointer to the ARM-specific arch data in the
> device struct, which will be used to attach iommu-specific data
> to devices which require iommu support.

Can you please take a look and ack/nack ?

With this change in hand, generic code will now be able to control
OMAP's iommu devices too, without having to use any OMAP-specific API
(this is demonstrated in this patch set).

This will allow us to further clean the existing mainline OMAP iommu
users, and focus on generic IOMMU code for future users
(rpmsg/remoteproc and Marek's upcoming generic DMA API).

The change is only effective when an iommu driver, which supports the
generic IOMMU API, is built (all of them must select
CONFIG_IOMMU_API), and otherwise is a nop.

Obviously the change itself is not OMAP-specific, and it will be
useful for other platforms too.

Thanks!
Ohad.

> Different iommu implementations (on different platforms) will attach
> different types of data to this pointer, so 'void *' is currently used
> (the downside is reduced typesafety).
>
> Note: ia64, x86 and sparc have this exact iommu extension as well, and
> if others are likely to adopt it too, we might want to consider
> adding this to the device struct itself directly.
>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/include/asm/device.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
> index 9f390ce..6615f03 100644
> --- a/arch/arm/include/asm/device.h
> +++ b/arch/arm/include/asm/device.h
> @@ -10,6 +10,9 @@ struct dev_archdata {
>  #ifdef CONFIG_DMABOUNCE
>        struct dmabounce_device_info *dmabounce;
>  #endif
> +#ifdef CONFIG_IOMMU_API
> +       void *iommu; /* private IOMMU data */
> +#endif
>  };
>
>  struct pdev_archdata {
> --
> 1.7.4.1
>
>
