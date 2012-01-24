Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2AXBUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:20:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42307 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab2AXBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:20:14 -0500
Date: Tue, 24 Jan 2012 12:20:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Boojin Kim <boojin.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120124122002.93bc4bb79de814f1f30f640a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Jan_2012_12_20_02_+1100_hF/o8Yj=edyIzpA9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jan_2012_12_20_02_+1100_hF/o8Yj=edyIzpA9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/dma.c between commit 20df8641cc1a ("ARM: amba:
samsung: get rid of NO_IRQ initializers") from the arm tree and commits
2b7841baf665 ("ARM: EXYNOS: Enable MDMA driver") and  bf2f272ad446 ("ARM:
EXYNOS: Support DMA for EXYNOS4X12 SoCs") from the arm-soc tree.

I fixed it up (there may be more required - see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/dma.c
index 91370de,ce645ba..0000000
--- a/arch/arm/mach-exynos/dma.c
+++ b/arch/arm/mach-exynos/dma.c
@@@ -69,15 -70,60 +70,47 @@@ u8 exynos4210_pdma0_peri[] =3D=20
  	DMACH_AC97_PCMOUT,
  };
 =20
- struct dma_pl330_platdata exynos4_pdma0_pdata =3D {
- 	.nr_valid_peri =3D ARRAY_SIZE(pdma0_peri),
- 	.peri_id =3D pdma0_peri,
+ u8 exynos4212_pdma0_peri[] =3D {
+ 	DMACH_PCM0_RX,
+ 	DMACH_PCM0_TX,
+ 	DMACH_PCM2_RX,
+ 	DMACH_PCM2_TX,
+ 	DMACH_MIPI_HSI0,
+ 	DMACH_MIPI_HSI1,
+ 	DMACH_SPI0_RX,
+ 	DMACH_SPI0_TX,
+ 	DMACH_SPI2_RX,
+ 	DMACH_SPI2_TX,
+ 	DMACH_I2S0S_TX,
+ 	DMACH_I2S0_RX,
+ 	DMACH_I2S0_TX,
+ 	DMACH_I2S2_RX,
+ 	DMACH_I2S2_TX,
+ 	DMACH_UART0_RX,
+ 	DMACH_UART0_TX,
+ 	DMACH_UART2_RX,
+ 	DMACH_UART2_TX,
+ 	DMACH_UART4_RX,
+ 	DMACH_UART4_TX,
+ 	DMACH_SLIMBUS0_RX,
+ 	DMACH_SLIMBUS0_TX,
+ 	DMACH_SLIMBUS2_RX,
+ 	DMACH_SLIMBUS2_TX,
+ 	DMACH_SLIMBUS4_RX,
+ 	DMACH_SLIMBUS4_TX,
+ 	DMACH_AC97_MICIN,
+ 	DMACH_AC97_PCMIN,
+ 	DMACH_AC97_PCMOUT,
+ 	DMACH_MIPI_HSI4,
+ 	DMACH_MIPI_HSI5,
  };
 =20
+ struct dma_pl330_platdata exynos4_pdma0_pdata;
+=20
 -struct amba_device exynos4_device_pdma0 =3D {
 -	.dev =3D {
 -		.init_name =3D "dma-pl330.0",
 -		.dma_mask =3D &dma_dmamask,
 -		.coherent_dma_mask =3D DMA_BIT_MASK(32),
 -		.platform_data =3D &exynos4_pdma0_pdata,
 -	},
 -	.res =3D {
 -		.start =3D EXYNOS4_PA_PDMA0,
 -		.end =3D EXYNOS4_PA_PDMA0 + SZ_4K,
 -		.flags =3D IORESOURCE_MEM,
 -	},
 -	.irq =3D {IRQ_PDMA0, NO_IRQ},
 -	.periphid =3D 0x00041330,
 -};
 +AMBA_AHB_DEVICE(exynos4_pdma0, "dma-pl330.0", 0x00041330, EXYNOS4_PA_PDMA=
0,
 +	{IRQ_PDMA0}, &exynos4_pdma0_pdata);
 =20
- u8 pdma1_peri[] =3D {
+ u8 exynos4210_pdma1_peri[] =3D {
  	DMACH_PCM0_RX,
  	DMACH_PCM0_TX,
  	DMACH_PCM1_RX,
@@@ -105,27 -151,121 +138,108 @@@
  	DMACH_SLIMBUS5_TX,
  };
 =20
- struct dma_pl330_platdata exynos4_pdma1_pdata =3D {
- 	.nr_valid_peri =3D ARRAY_SIZE(pdma1_peri),
- 	.peri_id =3D pdma1_peri,
+ u8 exynos4212_pdma1_peri[] =3D {
+ 	DMACH_PCM0_RX,
+ 	DMACH_PCM0_TX,
+ 	DMACH_PCM1_RX,
+ 	DMACH_PCM1_TX,
+ 	DMACH_MIPI_HSI2,
+ 	DMACH_MIPI_HSI3,
+ 	DMACH_SPI1_RX,
+ 	DMACH_SPI1_TX,
+ 	DMACH_I2S0S_TX,
+ 	DMACH_I2S0_RX,
+ 	DMACH_I2S0_TX,
+ 	DMACH_I2S1_RX,
+ 	DMACH_I2S1_TX,
+ 	DMACH_UART0_RX,
+ 	DMACH_UART0_TX,
+ 	DMACH_UART1_RX,
+ 	DMACH_UART1_TX,
+ 	DMACH_UART3_RX,
+ 	DMACH_UART3_TX,
+ 	DMACH_SLIMBUS1_RX,
+ 	DMACH_SLIMBUS1_TX,
+ 	DMACH_SLIMBUS3_RX,
+ 	DMACH_SLIMBUS3_TX,
+ 	DMACH_SLIMBUS5_RX,
+ 	DMACH_SLIMBUS5_TX,
+ 	DMACH_SLIMBUS0AUX_RX,
+ 	DMACH_SLIMBUS0AUX_TX,
+ 	DMACH_SPDIF,
+ 	DMACH_MIPI_HSI6,
+ 	DMACH_MIPI_HSI7,
  };
 =20
+ struct dma_pl330_platdata exynos4_pdma1_pdata;
+=20
 -struct amba_device exynos4_device_pdma1 =3D {
 -	.dev =3D {
 -		.init_name =3D "dma-pl330.1",
 -		.dma_mask =3D &dma_dmamask,
 -		.coherent_dma_mask =3D DMA_BIT_MASK(32),
 -		.platform_data =3D &exynos4_pdma1_pdata,
 -	},
 -	.res =3D {
 -		.start =3D EXYNOS4_PA_PDMA1,
 -		.end =3D EXYNOS4_PA_PDMA1 + SZ_4K,
 -		.flags =3D IORESOURCE_MEM,
 -	},
 -	.irq =3D {IRQ_PDMA1, NO_IRQ},
 -	.periphid =3D 0x00041330,
 -};
 +AMBA_AHB_DEVICE(exynos4_pdma1,  "dma-pl330.1", 0x00041330, EXYNOS4_PA_PDM=
A1,
 +	{IRQ_PDMA1}, &exynos4_pdma1_pdata);
 =20
+ u8 mdma_peri[] =3D {
+ 	DMACH_MTOM_0,
+ 	DMACH_MTOM_1,
+ 	DMACH_MTOM_2,
+ 	DMACH_MTOM_3,
+ 	DMACH_MTOM_4,
+ 	DMACH_MTOM_5,
+ 	DMACH_MTOM_6,
+ 	DMACH_MTOM_7,
+ };
+=20
+ struct dma_pl330_platdata exynos4_mdma_pdata =3D {
+ 	.nr_valid_peri =3D ARRAY_SIZE(mdma_peri),
+ 	.peri_id =3D mdma_peri,
+ };
+=20
+ struct amba_device exynos4_device_mdma =3D {
+ 	.dev =3D {
+ 		.init_name =3D "dma-pl330.2",
+ 		.dma_mask =3D &dma_dmamask,
+ 		.coherent_dma_mask =3D DMA_BIT_MASK(32),
+ 		.platform_data =3D &exynos4_mdma_pdata,
+ 	},
+ 	.res =3D {
+ 		.start =3D EXYNOS4_PA_MDMA1,
+ 		.end =3D EXYNOS4_PA_MDMA1 + SZ_4K,
+ 		.flags =3D IORESOURCE_MEM,
+ 	},
 -	.irq =3D {IRQ_MDMA1, NO_IRQ},
++	.irq =3D {IRQ_MDMA1},
+ 	.periphid =3D 0x00041330,
+ };
+=20
  static int __init exynos4_dma_init(void)
  {
  	if (of_have_populated_dt())
  		return 0;
 =20
+ 	if (soc_is_exynos4210()) {
+ 		exynos4_pdma0_pdata.nr_valid_peri =3D
+ 			ARRAY_SIZE(exynos4210_pdma0_peri);
+ 		exynos4_pdma0_pdata.peri_id =3D exynos4210_pdma0_peri;
+ 		exynos4_pdma1_pdata.nr_valid_peri =3D
+ 			ARRAY_SIZE(exynos4210_pdma1_peri);
+ 		exynos4_pdma1_pdata.peri_id =3D exynos4210_pdma1_peri;
+ 	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
+ 		exynos4_pdma0_pdata.nr_valid_peri =3D
+ 			ARRAY_SIZE(exynos4212_pdma0_peri);
+ 		exynos4_pdma0_pdata.peri_id =3D exynos4212_pdma0_peri;
+ 		exynos4_pdma1_pdata.nr_valid_peri =3D
+ 			ARRAY_SIZE(exynos4212_pdma1_peri);
+ 		exynos4_pdma1_pdata.peri_id =3D exynos4212_pdma1_peri;
+ 	}
+=20
  	dma_cap_set(DMA_SLAVE, exynos4_pdma0_pdata.cap_mask);
  	dma_cap_set(DMA_CYCLIC, exynos4_pdma0_pdata.cap_mask);
 -	amba_device_register(&exynos4_device_pdma0, &iomem_resource);
 +	amba_device_register(&exynos4_pdma0_device, &iomem_resource);
 =20
  	dma_cap_set(DMA_SLAVE, exynos4_pdma1_pdata.cap_mask);
  	dma_cap_set(DMA_CYCLIC, exynos4_pdma1_pdata.cap_mask);
 -	amba_device_register(&exynos4_device_pdma1, &iomem_resource);
 +	amba_device_register(&exynos4_pdma1_device, &iomem_resource);
 =20
+ 	dma_cap_set(DMA_MEMCPY, exynos4_mdma_pdata.cap_mask);
+ 	amba_device_register(&exynos4_device_mdma, &iomem_resource);
+=20
  	return 0;
  }
  arch_initcall(exynos4_dma_init);

--Signature=_Tue__24_Jan_2012_12_20_02_+1100_hF/o8Yj=edyIzpA9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHgdCAAoJEECxmPOUX5FEGZMQAKnpSz+iYr6Nlf+J4b/cgto3
kufU+uul/GtrcffKhgYrv7K6V7ifkVz3dJRH+7K6FPiEPoYFCGPvBdEz0WIkKf83
mTf4XliQXBHRV4nRJstwTkI/0zVFXeUffYaH1FwTnwc1Hym8KPyw4v1xUeiKaqYi
I3Im39TYojG3vtWS8MPGFu4nZiX41kTx011cRnmkCWAWAiYNCfkyjgN2nNkwJ0U2
BdCKajZDq5OAvuLWpWdOw2S4e6ZHr2CcJOTj16vsQ8mP4xOejj6IkwYPO4nnkwXf
LdO+XPMVwYbrjfmr3gG/efa/HJn75PkWQ8OV1HyG8XZbrfvM29PgUGWONpic9Zq3
KkooTxRFvT0s6dcZhEIuDkvccio9Yc+PZEbTh8yB+uJ1hkzxCT4ObBNcbW+V1Ouq
bM2a3fOhBCQjD9edk8yZTREaFXvuWdETfpNaQ+Hk+LR0CnjB2w9xtqu9hylTED5i
9JGVa90+r7fdJTJDzzEWBySGUr77O7eRQSTSc89M/tWfqyVQF2ixMCYvukAeHzl/
T6Et/Jv9DVUphpiU0zB2FsxnSAgtG+C5RSu5JapQvl3tBV89HWrSOxSrqcQ9LhQB
NRdwqlOSldurQT47AukspCBr28IVg/LANNrLlQoI7g0GNSOMQ5n+th2CG+jUKWt5
QzmhwZiy2ZzlXy8NZDPR
=TeD6
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jan_2012_12_20_02_+1100_hF/o8Yj=edyIzpA9--
