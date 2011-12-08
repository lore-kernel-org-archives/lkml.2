Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1LHHnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:43:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31716 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LHHnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:43:43 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-42-4ee06aabcd37
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, linaro-dev@lists.linaro.org, patches@linaro.org
References: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
 <1323168355-2764-3-git-send-email-tushar.behera@linaro.org>
In-reply-to: <1323168355-2764-3-git-send-email-tushar.behera@linaro.org>
Subject: RE: [PATCH 2/2] ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1
Date: Thu, 08 Dec 2011 16:43:39 +0900
Message-id: <002301ccb57d$19f09b40$4dd1d1c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy0BLssRER2yGtgQxOHB1SfS0vvcQBeFEew
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera wrote:
> 
> Amba core assumes the pclk to be named as apb_pclk. During device probe,
> it tries to get that clock and enable that. When PM_RUNTIME is enabled,
> dma clock is not explicitly enabled in pl330_probe, which causes device
> probe to fail. Adding a clkdev entry for apb_pclk for mdma1 fixes the
> problem.
> 
> This patch fixes following runtime error.
> 
> dma-pl330 dma-pl330.2: PERIPH_ID 0x0, PCELL_ID 0x0 !
> dma-pl330: probe of dma-pl330.2 failed with error -22
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  arch/arm/mach-exynos/clock.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/clock.c b/arch/arm/mach-exynos/clock.c
> index 28e2842..eb33a7a 100644
> --- a/arch/arm/mach-exynos/clock.c
> +++ b/arch/arm/mach-exynos/clock.c
> @@ -1326,6 +1326,7 @@ static struct clk_lookup exynos4_clk_lookup[] = {
>  	CLKDEV_INIT("s3c-sdhci.3", "mmc_busclk.2", &clk_sclk_mmc3.clk),
>  	CLKDEV_INIT("dma-pl330.0", "apb_pclk", &clk_pdma0),
>  	CLKDEV_INIT("dma-pl330.1", "apb_pclk", &clk_pdma1),
> +	CLKDEV_INIT("dma-pl330.2", "apb_pclk", &clk_mdma1),
>  };
> 
>  static int xtal_rate;
> --
> 1.7.4.1

Looks ok to me, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

