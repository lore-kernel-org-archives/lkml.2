Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab2DJDpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:45:52 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:53430 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab2DJDpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:45:50 -0400
Message-ID: <4F83AC80.1070204@st.com>
Date: Tue, 10 Apr 2012 09:14:00 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Anton Vorontsov <cbouatmailru@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: pxamci: Use DIV_ROUND_UP at appropriate places
References: <1334023210.16328.3.camel@phoenix>
In-Reply-To: <1334023210.16328.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2012 7:30 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mmc/host/pxamci.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
> index cb2dc0e..4b89e73 100644
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -190,7 +190,7 @@ static void pxamci_setup_data(struct pxamci_host *host, struct mmc_data *data)
>  	clks = (unsigned long long)data->timeout_ns * host->clkrate;
>  	do_div(clks, 1000000000UL);
>  	timeout = (unsigned int)clks + (data->timeout_clks << host->clkrt);
> -	writel((timeout + 255) / 256, host->base + MMC_RDTO);
> +	writel(DIV_ROUND_UP(timeout, 256), host->base + MMC_RDTO);
>  
>  	if (data->flags & MMC_DATA_READ) {
>  		host->dma_dir = DMA_FROM_DEVICE;
> @@ -636,7 +636,7 @@ static int pxamci_probe(struct platform_device *pdev)
>  	/*
>  	 * Calculate minimum clock rate, rounding up.
>  	 */
> -	mmc->f_min = (host->clkrate + 63) / 64;
> +	mmc->f_min = DIV_ROUND_UP(host->clkrate, 64);
>  	mmc->f_max = (mmc_has_26MHz()) ? 26000000 : host->clkrate;
>  
>  	pxamci_init_ocr(host);

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
