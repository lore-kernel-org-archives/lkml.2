Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0HJDIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:08:18 -0400
Received: from mail.perches.com ([173.55.12.10]:2344 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab0HJDIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:08:12 -0400
Subject: Re: [PATCH v3] arm: msm: Add MSM IOMMU support.
From: Joe Perches <joe@perches.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1281407259-28626-1-git-send-email-stepanm@codeaurora.org>
References: <1281407259-28626-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 20:08:09 -0700
Message-ID: <1281409689.1954.96.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 19:27 -0700, Stepan Moskovchenko wrote:
> Add support for the IOMMUs found on the upcoming Qualcomm
> MSM8x60 chips. These IOMMUs allow virtualization of the
> address space used by most of the multimedia cores on these
> chips. The driver implements the kernel's IOMMU API.
> diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
> new file mode 100644
> index 0000000..b22aecd
> --- /dev/null
> +++ b/arch/arm/mach-msm/iommu.c
> @@ -0,0 +1,601 @@

Why use both pr_err and printk(KERN_ERR ?

> +#define pr_fmt(fmt) "%s %i " fmt, __func__, __LINE__
> +		pr_err("bad size: %d\n", len);
> +		pr_err("null page table\n");
> +			pr_err("could not allocate second level table\n");
> +		pr_err("null page table\n");
> +		pr_err("first level PTE is 0\n");
> +	printk(KERN_ERR "FAR    = %08x    PAR    = %08x\n",
> +	printk(KERN_ERR "FSR    = %08x [%s%s%s%s%s%s%s%s%s%s]\n", fsr,
> +	printk(KERN_ERR "FSYNR0 = %08x    FSYNR1 = %08x\n",
> +	printk(KERN_ERR "TTBR0  = %08x    TTBR1  = %08x\n",
> +	printk(KERN_ERR "SCTLR  = %08x    ACTLR  = %08x\n",
> +	printk(KERN_ERR "PRRR   = %08x    NMRR   = %08x\n",
> +		pr_err("Invalid device ID in context interrupt handler\n");
> +	printk(KERN_ERR "===== WOAH! =====\n");
> +	printk(KERN_ERR "Unexpected IOMMU page fault!\n");
> +	printk(KERN_ERR "base = %08x\n", (unsigned int) base);
> +			printk(KERN_ERR "Fault occurred in context %d.\n", i);
> +			printk(KERN_ERR "Interesting registers:\n");
> +			printk(KERN_ERR "\n");


