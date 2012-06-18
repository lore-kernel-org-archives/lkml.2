Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2FRLNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:13:25 -0400
Received: from antcom.de ([188.40.178.216]:40159 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2FRLNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:13:20 -0400
Message-ID: <4FDF0D4E.7090303@antcom.de>
Date: Mon, 18 Jun 2012 13:13:18 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: spi-pl022: Adjust probe() to of_get_named_gpio()
 returning -EPROBE_DEFER
References: <1340011219-31657-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1340011219-31657-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 11:20 AM, Roland Stigge wrote:
> The patch to gpiolib-of.c providing -EPROBE_DEFER as a hint to defer
> of_get_named_gpio*() to a later probe() breaks spi-pl022.c.
> 
> This patch adjusts to this change, using -EPROBE_DEFER as indication to defer.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
> Applies to 3.5-rc3
> 
> Should this patch be joined with gpiolib-of's patch to of_get_named_gpio()? Or
> should they just be issued as a series?
> 
>  drivers/spi/spi-pl022.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/drivers/spi/spi-pl022.c
> +++ linux-2.6/drivers/spi/spi-pl022.c
> @@ -2075,7 +2075,7 @@ pl022_probe(struct amba_device *adev, co
>  	for (i = 0; i < num_cs; i++) {
>  		int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
>  
> -		if (cs_gpio == -ENODEV) {
> +		if (cs_gpio == -EPROBE_DEFER) {
>  			status = -EPROBE_DEFER;
>  			goto err_no_gpio;
>  		}

You can ignore this patch, Alexandre will merge this into his
yet-unapplied patch to support dt in spi-pl022.

Sorry for the noise,

Roland
