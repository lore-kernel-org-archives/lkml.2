Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1JRNBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:01:14 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6494 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab1JRNBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:01:10 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371K542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Julia Lawall <julia@diku.dk>, Liam Girdwood <lrg@ti.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource
 so it can be freed
Thread-Topic: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource
 so it can be freed
Thread-Index: AQHMjUB5s3E7QwZU6E+u2MmFpc2Kv5WCDyuw
Date: Tue, 18 Oct 2011 13:01:05 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7722AB64D@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1318909555-12933-1-git-send-email-julia@diku.dk>
In-Reply-To: <1318909555-12933-1-git-send-email-julia@diku.dk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk]
> Sent: Tuesday, October 18, 2011 11:46 AM
> To: Liam Girdwood
> Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela; Takashi
> Iwai; Dong Aisheng-B29396; Wolfram Sang; alsa-devel@alsa-project.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource
> so it can be freed
> 
> From: Julia Lawall <julia@diku.dk>
> 
> Add a new variable for storing resources accessed subsequent to the one
> accessed using request_mem_region, so the one accessed using
> request_mem_region can be released if needed.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> expression E, E1;
> identifier f;
> statement S1,S2,S3;
> @@
> 
> if (E == NULL)
> {
>   ... when != if (E == NULL || ...) S1 else S2
>       when != E = E1
> *E->f
>   ... when any
>   return ...;
> }
> else S3
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  sound/soc/mxs/mxs-saif.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c index
> 401944c..e12ff78 100644
> --- a/sound/soc/mxs/mxs-saif.c
> +++ b/sound/soc/mxs/mxs-saif.c
> @@ -617,7 +617,7 @@ static irqreturn_t mxs_saif_irq(int irq, void *dev_id)
> 
>  static int mxs_saif_probe(struct platform_device *pdev)  {
> -	struct resource *res;
> +	struct resource *res, *res1;
How about naming iores and dmares?

>  	struct mxs_saif *saif;
>  	struct mxs_saif_platform_data *pdata;
>  	int ret = 0;
> @@ -676,14 +676,14 @@ static int mxs_saif_probe(struct platform_device
> *pdev)
>  		goto failed_ioremap;
>  	}
> 
> -	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> -	if (!res) {
> +	res1 = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> +	if (!res1) {
>  		ret = -ENODEV;
>  		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
>  			ret);
>  		goto failed_ioremap;
>  	}
> -	saif->dma_param.chan_num = res->start;
> +	saif->dma_param.chan_num = res1->start;
> 
>  	saif->irq = platform_get_irq(pdev, 0);
>  	if (saif->irq < 0) {
> 

Regards
Dong Aisheng

