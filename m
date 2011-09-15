Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1IOCRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:17:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17776 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab1IOCRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:17:07 -0400
X-AuditID: cbfee61b-b7b7fae000005864-94-4e716020d42a
Date: Thu, 15 Sep 2011 11:17:03 +0900
From: Sangbeom Kim <sbkim73@samsung.com>
Subject: RE: [PATCH] ASoC: samsung: Fix checking return value of clk_get
In-reply-to: <1315925062.6042.1.camel@phoenix>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Christian Pellegrin'" <chripell@evolware.org>,
        "'Ben Dooks'" <ben@simtec.co.uk>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Message-id: <00ba01cc734d$8f9bf320$aed3d960$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcxyI6hNlLM3/la2QeS5fUpgHcuI4gBIGgGg
References: <1315925062.6042.1.camel@phoenix>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 22:44 +0800, Axel Lin wrote:
>  	s3c2412_i2s.iis_cclk = clk_get(dai->dev, "i2sclk");
> -	if (s3c2412_i2s.iis_cclk == NULL) {
> +	if (IS_ERR(s3c2412_i2s.iis_cclk)) {
>  		pr_err("failed to get i2sclk clock\n");
>  		iounmap(s3c2412_i2s.regs);
>  		return -ENODEV;
Why don't you use PTR_ERR() for return value?

> diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-
> i2s.c
> index 63d8849..9f888bc 100644
> --- a/sound/soc/samsung/s3c24xx-i2s.c
> +++ b/sound/soc/samsung/s3c24xx-i2s.c
> @@ -383,7 +383,7 @@ static int s3c24xx_i2s_probe(struct snd_soc_dai *dai)
>  		return -ENXIO;
> 
>  	s3c24xx_i2s.iis_clk = clk_get(dai->dev, "iis");
> -	if (s3c24xx_i2s.iis_clk == NULL) {
> +	if (IS_ERR(s3c24xx_i2s.iis_clk)) {
>  		pr_err("failed to get iis_clock\n");
>  		iounmap(s3c24xx_i2s.regs);
>  		return -ENODEV;
Ditto

> diff --git a/sound/soc/samsung/s3c24xx_uda134x.c
> b/sound/soc/samsung/s3c24xx_uda134x.c
> index dc9d551..4da57cd 100644
> --- a/sound/soc/samsung/s3c24xx_uda134x.c
> +++ b/sound/soc/samsung/s3c24xx_uda134x.c
> @@ -66,13 +66,13 @@ static int s3c24xx_uda134x_startup(struct
> snd_pcm_substream *substream)
>  	pr_debug("%s %d\n", __func__, clk_users);
>  	if (clk_users == 0) {
>  		xtal = clk_get(&s3c24xx_uda134x_snd_device->dev, "xtal");
> -		if (!xtal) {
> +		if (IS_ERR(xtal)) {
>  			printk(KERN_ERR "%s cannot get xtal\n", __func__);
>  			ret = -EBUSY;
Ditto

>  		} else {
>  			pclk = clk_get(&s3c24xx_uda134x_snd_device->dev,
>  				       "pclk");
> -			if (!pclk) {
> +			if (IS_ERR(pclk)) {
>  				printk(KERN_ERR "%s cannot get pclk\n",
>  				       __func__);
>  				clk_put(xtal);
> --
> 1.7.4.1
> 

Thanks,

Sangbeom

