Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab1KJNeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:34:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:43954 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab1KJNeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:34:18 -0500
Subject: Re: [RFC PATCH 01/17] powerpc/mpic: Fix bogus CONFIG_BOOKE conditional
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1320883635-17194-2-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 10 Nov 2011 07:33:11 -0600
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Milton Miller <miltonm@bga.com>, Timur Tabi <timur@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2D7772C1-2EFA-4F40-A3BF-BBCC377C32F3@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-2-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2011, at 6:06 PM, Kyle Moffett wrote:

> The code inside the conditional is only used by 85xx CoreNet fabric
> platforms, so add a new config define and use it where necessary.

1. why make the change
2. if you're using FSL_CORENET as a SoC feature CONFIG option than other bits of this patch are wrong

It should NOT be used in platforms/85xx/Makefile those should be left alone and FSL_CORENET should be selected by having E500MC or similar set.

> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
> arch/powerpc/platforms/85xx/Kconfig    |    5 +++++
> arch/powerpc/platforms/85xx/Makefile   |   11 ++++++-----
> arch/powerpc/platforms/Kconfig.cputype |    3 +++
> arch/powerpc/sysdev/mpic.c             |    6 ++----
> 4 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
> index 45023e2..9088381 100644
> --- a/arch/powerpc/platforms/85xx/Kconfig
> +++ b/arch/powerpc/platforms/85xx/Kconfig
> @@ -181,6 +181,7 @@ config P2041_RDB
> 	select GPIO_MPC8XXX
> 	select HAS_RAPIDIO
> 	select PPC_EPAPR_HV_PIC
> +	select FSL_CORENET
> 	help
> 	  This option enables support for the P2041 RDB board
> 
> @@ -194,6 +195,7 @@ config P3041_DS
> 	select GPIO_MPC8XXX
> 	select HAS_RAPIDIO
> 	select PPC_EPAPR_HV_PIC
> +	select FSL_CORENET
> 	help
> 	  This option enables support for the P3041 DS board
> 
> @@ -206,6 +208,7 @@ config P3060_QDS
> 	select MPC8xxx_GPIO
> 	select HAS_RAPIDIO
> 	select PPC_EPAPR_HV_PIC
> +	select FSL_CORENET
> 	help
> 	  This option enables support for the P3060 QDS board
> 
> @@ -219,6 +222,7 @@ config P4080_DS
> 	select GPIO_MPC8XXX
> 	select HAS_RAPIDIO
> 	select PPC_EPAPR_HV_PIC
> +	select FSL_CORENET
> 	help
> 	  This option enables support for the P4080 DS board
> 
> @@ -235,6 +239,7 @@ config P5020_DS
> 	select GPIO_MPC8XXX
> 	select HAS_RAPIDIO
> 	select PPC_EPAPR_HV_PIC
> +	select FSL_CORENET
> 	help
> 	  This option enables support for the P5020 DS board
> 
> diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
> index bc5acb9..c6d1334 100644
> --- a/arch/powerpc/platforms/85xx/Makefile
> +++ b/arch/powerpc/platforms/85xx/Makefile
> @@ -13,11 +13,12 @@ obj-$(CONFIG_MPC85xx_RDB) += mpc85xx_rdb.o
> obj-$(CONFIG_P1010_RDB)   += p1010rdb.o
> obj-$(CONFIG_P1022_DS)    += p1022_ds.o
> obj-$(CONFIG_P1023_RDS)   += p1023_rds.o
> -obj-$(CONFIG_P2041_RDB)   += p2041_rdb.o corenet_ds.o
> -obj-$(CONFIG_P3041_DS)    += p3041_ds.o corenet_ds.o
> -obj-$(CONFIG_P3060_QDS)   += p3060_qds.o corenet_ds.o
> -obj-$(CONFIG_P4080_DS)    += p4080_ds.o corenet_ds.o
> -obj-$(CONFIG_P5020_DS)    += p5020_ds.o corenet_ds.o
> +obj-$(CONFIG_P2041_RDB)   += p2041_rdb.o
> +obj-$(CONFIG_P3041_DS)    += p3041_ds.o
> +obj-$(CONFIG_P3060_QDS)   += p3060_qds.o
> +obj-$(CONFIG_P4080_DS)    += p4080_ds.o
> +obj-$(CONFIG_P5020_DS)    += p5020_ds.o
> +obj-$(CONFIG_FSL_CORENET) += corenet_ds.o
> obj-$(CONFIG_STX_GP3)	  += stx_gp3.o
> obj-$(CONFIG_TQM85xx)	  += tqm85xx.o
> obj-$(CONFIG_SBC8560)     += sbc8560.o
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index fbecae0..9210e94 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -177,6 +177,9 @@ config FSL_BOOKE
> 	select SYS_SUPPORTS_HUGETLBFS if PHYS_64BIT
> 	default y
> 
> +config FSL_CORENET
> +	bool
> +
> # this is for common code between PPC32 & PPC64 FSL BOOKE
> config PPC_FSL_BOOK3E
> 	bool
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 0842c6f..1a3d84a 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -1642,9 +1642,9 @@ unsigned int mpic_get_irq(void)
> 	return mpic_get_one_irq(mpic);
> }
> 
> +#ifdef CONFIG_FSL_CORENET
> unsigned int mpic_get_coreint_irq(void)
> {
> -#ifdef CONFIG_BOOKE
> 	struct mpic *mpic = mpic_primary;
> 	u32 src;
> 
> @@ -1664,10 +1664,8 @@ unsigned int mpic_get_coreint_irq(void)
> 	}
> 
> 	return irq_linear_revmap(mpic->irqhost, src);
> -#else
> -	return NO_IRQ;
> -#endif
> }
> +#endif
> 
> unsigned int mpic_get_mcirq(void)
> {
> -- 
> 1.7.2.5

