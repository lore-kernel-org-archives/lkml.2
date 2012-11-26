Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2KZPpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:45:33 -0500
Received: from void.printf.net ([89.145.121.20]:43437 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab2KZPpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:45:32 -0500
From: Chris Ball <cjb@laptop.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 2/2] mmc: sdhci-spear: Don't call clk_{un}prepare() in suspend resume
References: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
	<e677b5b8e17c2349d624e949722f4ab1a5e1698c.1352387305.git.viresh.kumar@linaro.org>
Date: Mon, 26 Nov 2012 10:45:28 -0500
In-Reply-To: <e677b5b8e17c2349d624e949722f4ab1a5e1698c.1352387305.git.viresh.kumar@linaro.org>
	(Viresh Kumar's message of "Thu, 8 Nov 2012 20:39:10 +0530")
Message-ID: <87fw3w9xlz.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 08 2012, Viresh Kumar wrote:
> clk_{un}prepare is mandatory for platforms using common clock framework. Because
> for SPEAr we don't do anything in clk_{un}prepare() calls, just call them ones
> in probe/remove.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/mmc/host/sdhci-spear.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
> index fea8bf9..87a7009 100644
> --- a/drivers/mmc/host/sdhci-spear.c
> +++ b/drivers/mmc/host/sdhci-spear.c
> @@ -302,7 +302,7 @@ static int sdhci_suspend(struct device *dev)
>  
>  	ret = sdhci_suspend_host(host);
>  	if (!ret)
> -		clk_disable_unprepare(sdhci->clk);
> +		clk_disable(sdhci->clk);
>  
>  	return ret;
>  }
> @@ -313,7 +313,7 @@ static int sdhci_resume(struct device *dev)
>  	struct spear_sdhci *sdhci = dev_get_platdata(dev);
>  	int ret;
>  
> -	ret = clk_prepare_enable(sdhci->clk);
> +	ret = clk_enable(sdhci->clk);
>  	if (ret) {
>  		dev_dbg(dev, "Resume: Error enabling clock\n");
>  		return ret;

Thanks, pushed to mmc-next for 3.8.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
