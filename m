Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1K0Nmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 08:42:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51269 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1K0Nmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 08:42:53 -0500
MIME-Version: 1.0
In-Reply-To: <1322283343.14278.2.camel@phoenix>
References: <1322283343.14278.2.camel@phoenix>
Date: Sun, 27 Nov 2011 19:12:51 +0530
Message-ID: <CAOh2x=mF2x+8DG0D2RiEoGsk4kFvi8S5V_MaWYVBP4B5m1sJvQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: convert drivers/mmc/host/* to use module_platform_driver()
From: viresh kumar <viresh.linux@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Micha <mirq-linux@rere.qmqm.pl>,
        David Brown <davidb@codeaurora.org>, Ben Dooks <ben-linux@fluff.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:25 AM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/mmc/host/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mmc/host/bfin_sdh.c        |   12 +-----------
>  drivers/mmc/host/cb710-mmc.c       |   13 +------------
>  drivers/mmc/host/jz4740_mmc.c      |   12 +-----------
>  drivers/mmc/host/msm_sdcc.c        |   13 +------------
>  drivers/mmc/host/mxcmmc.c          |   13 +------------
>  drivers/mmc/host/mxs-mmc.c         |   13 +------------
>  drivers/mmc/host/pxamci.c          |   13 +------------
>  drivers/mmc/host/s3cmci.c          |   13 +------------
>  drivers/mmc/host/sdhci-cns3xxx.c   |   12 +-----------
>  drivers/mmc/host/sdhci-dove.c      |   12 +-----------
>  drivers/mmc/host/sdhci-esdhc-imx.c |   12 +-----------
>  drivers/mmc/host/sdhci-of-esdhc.c  |   12 +-----------
>  drivers/mmc/host/sdhci-of-hlwd.c   |   12 +-----------
>  drivers/mmc/host/sdhci-pxav2.c     |   12 +-----------
>  drivers/mmc/host/sdhci-pxav3.c     |   12 +-----------
>  drivers/mmc/host/sdhci-s3c.c       |   13 +------------
>  drivers/mmc/host/sdhci-spear.c     |   12 +-----------
>  drivers/mmc/host/sdhci-tegra.c     |   12 +-----------
>  drivers/mmc/host/sh_mmcif.c        |   14 +-------------
>  drivers/mmc/host/sh_mobile_sdhi.c  |   13 +------------
>  drivers/mmc/host/tmio_mmc.c        |   14 +-------------
>  21 files changed, 21 insertions(+), 243 deletions(-)
>

> diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
> index dee70b6..883548e 100644
> --- a/drivers/mmc/host/sdhci-spear.c
> +++ b/drivers/mmc/host/sdhci-spear.c
> @@ -320,17 +320,7 @@ static struct platform_driver sdhci_driver = {
>        .remove         = __devexit_p(sdhci_remove),
>  };
>
> -static int __init sdhci_init(void)
> -{
> -       return platform_driver_register(&sdhci_driver);
> -}
> -module_init(sdhci_init);
> -
> -static void __exit sdhci_exit(void)
> -{
> -       platform_driver_unregister(&sdhci_driver);
> -}
> -module_exit(sdhci_exit);
> +module_platform_driver(sdhci_driver);
>
>  MODULE_DESCRIPTION("SPEAr Secure Digital Host Controller Interface driver");
>  MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");

For SPEAr:

Acked-by: Viresh Kumar <viresh.linux@gmail.com>
