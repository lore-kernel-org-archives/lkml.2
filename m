Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2FTFqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:46:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:54936 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2FTFqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:46:19 -0400
Message-ID: <1340171140.28143.72.camel@pasglop>
Subject: Re: [PATCH v2 1/7] driver core: Add iommu_group tracking to struct
 device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, bhelgaas@google.com, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com, liuj97@gmail.com
Date: Wed, 20 Jun 2012 15:45:40 +1000
In-Reply-To: <20120530201840.31527.47813.stgit@bling.home>
References: <20120530201424.31527.33142.stgit@bling.home>
	 <20120530201840.31527.47813.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 14:18 -0600, Alex Williamson wrote:
> IOMMU groups allow IOMMU drivers to represent DMA visibility
> and isolation of devices.  Multiple devices may be grouped
> together for the purposes of DMA.  Placing a pointer on
> struct device enable easy access for things like streaming
> DMA programming and drivers like VFIO.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> 
>  include/linux/device.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 161d962..d0e4d99 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -36,6 +36,7 @@ struct subsys_private;
>  struct bus_type;
>  struct device_node;
>  struct iommu_ops;
> +struct iommu_group;
>  
>  struct bus_attribute {
>  	struct attribute	attr;
> @@ -687,6 +688,7 @@ struct device {
>  	const struct attribute_group **groups;	/* optional groups */
>  
>  	void	(*release)(struct device *dev);
> +	struct iommu_group	*iommu_group;
>  };
>  
>  /* Get the wakeup routines, which depend on struct device */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


