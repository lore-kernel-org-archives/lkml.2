Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1K1Dr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:47:29 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:60162 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141Ab1K1Dr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:47:28 -0500
Message-ID: <4ED30351.7090809@st.com>
Date: Mon, 28 Nov 2011 09:13:13 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sylvain Munaut <tnt@246tNt.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Mark Miesfeld <mmiesfeld@amcc.com>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [PATCH] SATA/PATA: convert drivers/ata/* to use module_platform_driver()
References: <1322376266.2226.3.camel@phoenix>
In-Reply-To: <1322376266.2226.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 12:14 PM, Axel Lin wrote:
> This patch converts the drivers in drivers/ata/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Sylvain Munaut <tnt@246tNt.com>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Mark Miesfeld <mmiesfeld@amcc.com>
> Cc: Ashish Kalra <ashish.kalra@freescale.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/ata/pata_arasan_cf.c   |   12 +-----------
>  drivers/ata/pata_at91.c        |   15 +--------------
>  drivers/ata/pata_imx.c         |   12 +-----------
>  drivers/ata/pata_ixp4xx_cf.c   |   13 +------------
>  drivers/ata/pata_mpc52xx.c     |   21 +--------------------
>  drivers/ata/pata_of_platform.c |   12 +-----------
>  drivers/ata/pata_palmld.c      |   13 +------------
>  drivers/ata/pata_platform.c    |   12 +-----------
>  drivers/ata/pata_pxa.c         |   13 +------------
>  drivers/ata/pata_rb532_cf.c    |   21 ++-------------------
>  drivers/ata/sata_dwc_460ex.c   |   13 +------------
>  drivers/ata/sata_fsl.c         |   14 +-------------
>  12 files changed, 13 insertions(+), 158 deletions(-)
> 
> diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
> index e8574bb..048589f 100644
> --- a/drivers/ata/pata_arasan_cf.c
> +++ b/drivers/ata/pata_arasan_cf.c
> @@ -963,17 +963,7 @@ static struct platform_driver arasan_cf_driver = {
>  	},
>  };
>  
> -static int __init arasan_cf_init(void)
> -{
> -	return platform_driver_register(&arasan_cf_driver);
> -}
> -module_init(arasan_cf_init);
> -
> -static void __exit arasan_cf_exit(void)
> -{
> -	platform_driver_unregister(&arasan_cf_driver);
> -}
> -module_exit(arasan_cf_exit);
> +module_platform_driver(arasan_cf_driver);
>  
>  MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
>  MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");

For SPEAr:

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
