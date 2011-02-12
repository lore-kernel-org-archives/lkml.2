Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab1BLCuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:50:13 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47640 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab1BLCuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:50:11 -0500
Date: Fri, 11 Feb 2011 18:50:01 -0800
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: Move CS5536-related constants to cs5535.h
Message-ID: <20110211185001.33aa4127@debxo>
In-Reply-To: <20110210171009.7D8399D401D@zog.reactivated.net>
References: <20110210171009.7D8399D401D@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Andres Salomon <dilinger@queued.net>

On Thu, 10 Feb 2011 17:10:09 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> Move these definitions into the relevant header file.
> This was requested in the review of the upcoming XO-1 suspend/resume
> code.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/platform/olpc/olpc-xo1.c |   26 ++++++++------------------
>  include/linux/cs5535.h            |   21 +++++++++++++++++++++
>  2 files changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/platform/olpc/olpc-xo1.c
> b/arch/x86/platform/olpc/olpc-xo1.c index 1277756..a2210ca 100644
> --- a/arch/x86/platform/olpc/olpc-xo1.c
> +++ b/arch/x86/platform/olpc/olpc-xo1.c
> @@ -12,6 +12,7 @@
>   * (at your option) any later version.
>   */
>  
> +#include <linux/cs5535.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm.h>
> @@ -21,17 +22,6 @@
>  
>  #define DRV_NAME "olpc-xo1"
>  
> -/* PMC registers (PMS block) */
> -#define PM_SCLK		0x10
> -#define PM_IN_SLPCTL	0x20
> -#define PM_WKXD		0x34
> -#define PM_WKD		0x30
> -#define PM_SSC		0x54
> -
> -/* PM registers (ACPI block) */
> -#define PM1_CNT		0x08
> -#define PM_GPE0_STS	0x18
> -
>  static unsigned long acpi_base;
>  static unsigned long pms_base;
>  
> @@ -40,17 +30,17 @@ static void xo1_power_off(void)
>  	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
>  
>  	/* Enable all of these controls with 0 delay */
> -	outl(0x40000000, pms_base + PM_SCLK);
> -	outl(0x40000000, pms_base + PM_IN_SLPCTL);
> -	outl(0x40000000, pms_base + PM_WKXD);
> -	outl(0x40000000, pms_base + PM_WKD);
> +	outl(0x40000000, pms_base + CS5536_PM_SCLK);
> +	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
> +	outl(0x40000000, pms_base + CS5536_PM_WKXD);
> +	outl(0x40000000, pms_base + CS5536_PM_WKD);
>  
>  	/* Clear status bits (possibly unnecessary) */
> -	outl(0x0002ffff, pms_base  + PM_SSC);
> -	outl(0xffffffff, acpi_base + PM_GPE0_STS);
> +	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
> +	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
>  
>  	/* Write SLP_EN bit to start the machinery */
> -	outl(0x00002000, acpi_base + PM1_CNT);
> +	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
>  }
>  
>  static int __devinit olpc_xo1_probe(struct platform_device *pdev)
> diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
> index 6fe2114..e46b8b0 100644
> --- a/include/linux/cs5535.h
> +++ b/include/linux/cs5535.h
> @@ -49,6 +49,27 @@
>  #define LBAR_ACPI_SIZE		0x40
>  #define LBAR_PMS_SIZE		0x80
>  
> +/*
> + * PMC registers (PMS block)
> + * It is only safe to access these registers as dword accesses.
> + * See CS5536 Specification Update erratas 17 & 18
> + */
> +#define CS5536_PM_SCLK		0x10
> +#define CS5536_PM_IN_SLPCTL	0x20
> +#define CS5536_PM_WKXD		0x34
> +#define CS5536_PM_WKD		0x30
> +#define CS5536_PM_SSC		0x54
> +
> +/*
> + * PM registers (ACPI block)
> + * It is only safe to access these registers as dword accesses.
> + * See CS5536 Specification Update erratas 17 & 18
> + */
> +#define CS5536_PM1_STS		0x00
> +#define CS5536_PM1_EN		0x02
> +#define CS5536_PM1_CNT		0x08
> +#define CS5536_PM_GPE0_STS	0x18
> +
>  /* VSA2 magic values */
>  #define VSA_VRC_INDEX		0xAC1C
>  #define VSA_VRC_DATA		0xAC1E

