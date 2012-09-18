Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2IRSEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:04:44 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:51984 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961Ab2IRSEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:04:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+aaY+XudBYupQu/6LEm6jt
Date: Tue, 18 Sep 2012 11:04:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Benoit Cousson <b-cousson@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 7/9] ARM: OMAP: iommu: optimize save and restore
 routines
Message-ID: <20120918180430.GV11762@atomide.com>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
 <1347479152-588-8-git-send-email-omar.luna@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347479152-588-8-git-send-email-omar.luna@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Omar Ramirez Luna <omar.luna@linaro.org> [120912 12:47]:
> --- a/arch/arm/plat-omap/include/plat/iommu.h
> +++ b/arch/arm/plat-omap/include/plat/iommu.h
> @@ -27,6 +27,13 @@ struct iotlb_entry {
>  	};
>  };
>  
> +/* context registers */
> +struct iommu_regs {
> +	u32 irqen;
> +	u32 cntl;
> +	u32 ttb;
> +};
> +
>  struct omap_iommu {
>  	const char	*name;
>  	struct module	*owner;
> @@ -50,7 +57,8 @@ struct omap_iommu {
>  	struct list_head	mmap;
>  	struct mutex		mmap_lock; /* protect mmap */
>  
> -	void *ctx; /* iommu context: registres saved area */
> +	struct iommu_regs context;
> +	int ctx_loss_cnt;
>  	u32 da_start;
>  	u32 da_end;
>  };
> --- a/arch/arm/plat-omap/include/plat/iommu2.h
> +++ b/arch/arm/plat-omap/include/plat/iommu2.h
> @@ -35,8 +35,6 @@
>  #define MMU_READ_RAM		0x6c
>  #define MMU_EMU_FAULT_AD	0x70
>  
> -#define MMU_REG_SIZE		256
> -
>  /*
>   * MMU Register bit definitions
>   */

These headers should be moved to include/linux/platform_data/iommu-omap.h
or something like that. Care to take care of that too?

I guess there's no reason to have both iommu.h and iommuh2.h?

Regards,

Tony
