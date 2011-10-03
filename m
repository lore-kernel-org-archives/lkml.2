Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1JCIcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:32:47 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:57412
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751957Ab1JCIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:32:40 -0400
Message-ID: <4E897318.3090004@compulab.co.il>
Date: Mon, 03 Oct 2011 10:32:24 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mmc: sdhci-tegra: Add #ifdef CONFIG_OF guard for of_find_property
References: <1317614852.30838.1.camel@phoenix>
In-Reply-To: <1317614852.30838.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On 10/03/11 06:07, Axel Lin wrote:
> I got below build error with "make tegra_defconfig;make"
> Add #ifdef CONFIG_OF guard for of_find_property to fix below build error:
> 
>   CC      drivers/mmc/host/sdhci-tegra.o
> drivers/mmc/host/sdhci-tegra.c: In function 'sdhci_tegra_dt_parse_pdata':
> drivers/mmc/host/sdhci-tegra.c:157: error: implicit declaration of function 'of_find_property'
> make[3]: *** [drivers/mmc/host/sdhci-tegra.o] Error 1
> make[2]: *** [drivers/mmc/host] Error 2
> make[1]: *** [drivers/mmc] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I got the build error on linux-next (20110930).
> Axel
> 
>  drivers/mmc/host/sdhci-tegra.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 67176afc..3883602 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -154,8 +154,11 @@ static struct tegra_sdhci_platform_data * __devinit sdhci_tegra_dt_parse_pdata(
>  	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
>  	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
>  	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
> +
> +#ifdef CONFIG_OF
>  	if (of_find_property(np, "support-8bit", NULL))
>  		plat->is_8bit = 1;
> +#endif

Shouldn't we add a stub for the of_find_property() method to include/linux/of.h
instead of adding more ifdefs?
Or may be use of_get_property() method instead?

>  
>  	return plat;
>  }

-- 
Regards,
Igor.
