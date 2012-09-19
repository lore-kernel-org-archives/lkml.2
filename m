Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2ISOXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:23:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:51597 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2ISOXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:23:38 -0400
Subject: Re: [RFC][PATCH 1/3] iommu/fsl: Store iommu domain information pointer in archdata.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1348060632-12997-2-git-send-email-b16395@freescale.com>
Date: Wed, 19 Sep 2012 08:50:14 -0500
Cc: <iommu@lists.linux-foundation.org>, <joerg.roedel@amd.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5BDB4D18-CB0D-4EBA-B38F-A278B7C00A61@kernel.crashing.org>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com> <1348060632-12997-2-git-send-email-b16395@freescale.com>
To: "<b16395@freescale.com>" <b16395@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com> <b16395@freescale.com> wrote:

> From: Varun Sethi <Varun.Sethi@freescale.com>
> 
> Add a new field in the device (powerpc) archdata structure for storing iommu domain
> information pointer. This pointer is stored when the device is attached to a particular
> domain.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> arch/powerpc/include/asm/device.h |    4 ++++
> 1 files changed, 4 insertions(+), 0 deletions(-)

Not too familiar, but what does the IBM Server IOMMU do for iommu_domain?

> 
> diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
> index 77e97dd..6dc79fe 100644
> --- a/arch/powerpc/include/asm/device.h
> +++ b/arch/powerpc/include/asm/device.h
> @@ -28,6 +28,10 @@ struct dev_archdata {
> 		void		*iommu_table_base;
> 	} dma_data;
> 
> +	/* IOMMU domain information pointer. This would be set
> +	 * when this device is attached to an iommu_domain.
> +	 */
> +	void			*iommu_domain;
> #ifdef CONFIG_SWIOTLB
> 	dma_addr_t		max_direct_dma_addr;
> #endif
> -- 
> 1.7.4.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

