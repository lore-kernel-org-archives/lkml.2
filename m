Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0KHWME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:12:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63634 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab0KHWMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=epSIhXh1zhLR0hVRFBYlwiNni22q5RPbQlympW98svLeZDNAro8oE7nz3xJ1UY526b
         oPnPgd/8+Srns6tJoUVcVuqDymbMJi5jDb01tZcZUfrj23skLB9UmU2L5l+pyZxpQjoU
         5bdJsJUHNDyOZBcIA1BUr92REKAnwhWLnXVso=
MIME-Version: 1.0
In-Reply-To: <1288656337.29881.13.camel@realization>
References: <1288656337.29881.13.camel@realization>
Date: Mon, 8 Nov 2010 23:12:01 +0100
Message-ID: <AANLkTi=oKHTmLS=xiNi9CJKttBGzMHjhZ3q_KWvi+xta@mail.gmail.com>
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage the
 MMC card voltage
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Daniel Mack <daniel@caiaq.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Alberto Panizzo <maramaopercheseimorto@gmail.com>:

> +static inline void mxcmci_init_ocr(struct mxcmci_host *host)
> +{
> +#ifdef CONFIG_REGULATOR
> +       host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
> +
> +       if (IS_ERR(host->vcc)) {
> +               host->vcc = NULL;
> +       } else {
> +               host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->vcc);
> +               if (host->pdata && host->pdata->ocr_avail)
> +                       dev_warn(mmc_dev(host->mmc),
> +                               "pdata->ocr_avail will not be used\n");
> +       }
> +#endif

You don't need these #ifdef CONFIG_REGULATOR guardposts
anymore. I implemented stub functions for the ocrmask functions
for 2.6.37.

> +static inline void mxcmci_set_power(struct mxcmci_host *host, unsigned int vdd)
> +{
> +#ifdef CONFIG_REGULATOR
> +       if (host->vcc)
> +               mmc_regulator_set_ocr(host->vcc, vdd);
> +#endif

Neither here.

But for both cases: no big deal. Take it the day it disturbs you :-)

Yours,
Linus Walleij
