Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2KZPJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:09:10 -0500
Received: from void.printf.net ([89.145.121.20]:47376 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab2KZPJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:09:08 -0500
From: Chris Ball <cjb@laptop.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH 1/2] mmc: sdhci-spear: Initialize sdhci clk to 50 MHz
References: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
Date: Mon, 26 Nov 2012 10:09:01 -0500
In-Reply-To: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
	(Viresh Kumar's message of "Thu, 8 Nov 2012 20:39:09 +0530")
Message-ID: <87obik9zaq.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 08 2012, Viresh Kumar wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>
> SPEAr sdhci driver expects the clock to be set to 50 MHz for proper functioning.
> This patch sets clk to 50 MHz in probe.
>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/mmc/host/sdhci-spear.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
> index 6be89c0..fea8bf9 100644
> --- a/drivers/mmc/host/sdhci-spear.c
> +++ b/drivers/mmc/host/sdhci-spear.c
> @@ -146,6 +146,11 @@ static int __devinit sdhci_probe(struct platform_device *pdev)
>  		goto put_clk;
>  	}
>  
> +	ret = clk_set_rate(sdhci->clk, 50000000);
> +	if (ret)
> +		dev_dbg(&pdev->dev, "Error setting desired clk, clk=%lu\n",
> +				clk_get_rate(sdhci->clk));
> +
>  	if (np) {
>  		sdhci->data = sdhci_probe_config_dt(pdev);
>  		if (IS_ERR(sdhci->data)) {

Can I change this to a dev_err()?  No-one's going to see a dev_dbg().

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
