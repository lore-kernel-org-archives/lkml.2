Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1HUK3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 06:29:11 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:57159
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726Ab1HUK3I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 06:29:08 -0400
X-SpamScore: -24
X-BigFish: VS-24(zz9371K1447R542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Julia Lawall <julia@diku.dk>, Wolfram Sang <w.sang@pengutronix.de>
CC: Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/4] sound/soc/mxs/mxs-saif.c: add missing kfree
Thread-Topic: [PATCH 3/4] sound/soc/mxs/mxs-saif.c: add missing kfree
Thread-Index: AQHMXwAxou2jqcv6zUmMuj43WFOyZZUmFG6AgAAaPoCAAOaKMA==
Date: Sun, 21 Aug 2011 10:29:04 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7722212DF@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1313820761-12042-3-git-send-email-julia@diku.dk>
 <20110820134439.GA2266@pengutronix.de>
 <Pine.LNX.4.64.1108201718200.30651@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1108201718200.30651@ask.diku.dk>
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
> Sent: Saturday, August 20, 2011 11:19 PM
> To: Wolfram Sang
> Cc: Liam Girdwood; kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav
> Kysela; Takashi Iwai; Dong Aisheng-B29396; alsa-devel@alsa-project.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/4] sound/soc/mxs/mxs-saif.c: add missing kfree
> 
> From: Julia Lawall <julia@diku.dk>
> 
> Move the test on pdev->id before the kzalloc to avoid requiring kfree
> when the test fails.  This fix was suggested by Wolfram Sang.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> expression E1!=0,E2,E3,E4;
> statement S;
> iterator I;
> @@
> 
> (
> if (...) { ... when != kfree(x)
>                when != x = E3
>                when != E3 = x
> *  return ...;
>  }
> ... when != x = E2
>     when != I(...,x,...) S
> if (...) { ... when != x = E4
>  kfree(x); ... return ...; }
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c index
> 0b3adae..e9a90e4 100644
> --- a/sound/soc/mxs/mxs-saif.c
> +++ b/sound/soc/mxs/mxs-saif.c
> @@ -519,12 +519,11 @@ static int mxs_saif_probe(struct platform_device
> *pdev)
>  	struct mxs_saif *saif;
>  	int ret = 0;
> 
> +	if (pdev->id >= ARRAY_SIZE(mxs_saif))
> +		return -EINVAL;
>  	saif = kzalloc(sizeof(*saif), GFP_KERNEL);
>  	if (!saif)
>  		return -ENOMEM;
> -
> -	if (pdev->id >= ARRAY_SIZE(mxs_saif))
> -		return -EINVAL;
>  	mxs_saif[pdev->id] = saif;
> 
>  	saif->clk = clk_get(&pdev->dev, NULL);

Thanks for the finding, Julia.
It's ok to me.

BTW I guess you may need to resend a new version patch instead of following it
in this mail thread. :)
If yes, one minus thing, add one blank line below the line of 'return -ENOMEM'
may look more comfortable.

Regards
Dong Aisheng


