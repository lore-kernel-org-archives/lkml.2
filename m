Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1JaEVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 00:21:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:36405 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1JaEVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 00:21:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,429,1315206000"; 
   d="scan'208";a="68668417"
Subject: Re: [PATCH 1/2] pch_dma: Support new device LAPIS Semiconductor
 ML7831 IOH
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <1319761790-6882-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319761790-6882-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 09:48:09 +0530
Message-ID: <1320034689.20054.236.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 09:29 +0900, Tomoya MORINAGA wrote:
> ML7831 is companion chip for Intel Atom E6xx series.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> ---
>  drivers/dma/Kconfig   |   14 +++++++-------
>  drivers/dma/pch_dma.c |    6 +++++-
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index ab8f469..22439e2 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -201,18 +201,18 @@ config PL330_DMA
>  	  platform_data for a dma-pl330 device.
>  
>  config PCH_DMA
> -	tristate "Intel EG20T PCH / OKI Semi IOH(ML7213/ML7223) DMA support"
> +	tristate "Intel EG20T PCH / LAPIS Semicon IOH(ML7213/ML7223/ML7831) DMA"
Shouldn't this be in 2/2 where you are doing the name change
>  	depends on PCI && X86
>  	select DMA_ENGINE
>  	help
>  	  Enable support for Intel EG20T PCH DMA engine.
>  
> -	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
> -	  Output Hub), ML7213 and ML7223.
> -	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
> -	  for MP(Media Phone) use.
> -	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
> -	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
> +	  This driver also can be used for LAPIS Semiconductor IOH(Input/
> +	  Output Hub), ML7213, ML7223 and ML7831.
> +	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use, ML7223 IOH is
> +	  for MP(Media Phone) use and ML7831 IOH is for general purpose use.
> +	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
> +	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
>  
>  config IMX_SDMA
>  	tristate "i.MX SDMA support"
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index a6d0e3d..a46bedb 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -1018,6 +1018,8 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
>  #define PCI_DEVICE_ID_ML7223_DMA2_4CH	0x800E
>  #define PCI_DEVICE_ID_ML7223_DMA3_4CH	0x8017
>  #define PCI_DEVICE_ID_ML7223_DMA4_4CH	0x803B
> +#define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
> +#define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
>  
>  DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
> @@ -1030,6 +1032,8 @@ DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA2_4CH), 4}, /* Video SPI */
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA3_4CH), 4}, /* Security */
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_DMA4_4CH), 4}, /* FPGA */
> +	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_DMA1_8CH), 8}, /* UART */
> +	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7831_DMA2_4CH), 4}, /* SPI */
>  	{ 0, },
>  };
>  
> @@ -1057,7 +1061,7 @@ static void __exit pch_dma_exit(void)
>  module_init(pch_dma_init);
>  module_exit(pch_dma_exit);
>  
> -MODULE_DESCRIPTION("Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH "
> +MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213/ML7223/ML7831 IOH "
>  		   "DMA controller driver");
>  MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
>  MODULE_LICENSE("GPL v2");


-- 
~Vinod

