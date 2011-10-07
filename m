Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab1JGKbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:31:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34318 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862Ab1JGKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:31:22 -0400
Date: Fri, 7 Oct 2011 11:27:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com
Subject: Re: [PATCH v3 1/2] ARM: EXYNOS4: Change System MMU device
	definition
Message-ID: <20111007102754.GF21464@n2100.arm.linux.org.uk>
References: <01e001cc84d7$5e0b84b0$1a228e10$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e001cc84d7$5e0b84b0$1a228e10$%kim@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 06:56:21PM +0900, Kukjin Kim wrote:
> +#define SYSMMU_RESOURCE(ipname, base, irq) \
> +static struct resource sysmmu_resource_##ipname[] =\
> +{\
> +	{\
> +		.start	= EXYNOS4_PA_SYSMMU_##base,\
> +		.end	= EXYNOS4_PA_SYSMMU_##base + SZ_4K - 1,\
> +		.flags	= IORESOURCE_MEM,\
> +	}, {\
> +		.start	= IRQ_SYSMMU_##irq##_0,\
> +		.end	= IRQ_SYSMMU_##irq##_0,\
> +		.flags	= IORESOURCE_IRQ,\
> +	},\
>  }

#define SYSMMU_RESOURCE(ipname, base, irq) \
static struct resource sysmmu_resource_##ipname[] = \
{ \
	DEFINE_RES_MEM(EXYNOS4_PA_SYSMMU_##base, SZ_4K), \
	DEFINE_RES_IRQ(IRQ_SYSMMU_##irq##_0), \
}

