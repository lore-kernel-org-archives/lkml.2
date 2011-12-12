Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1LLJwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:52:17 -0500
Received: from smtp4.epfl.ch ([128.178.224.218]:37658 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751290Ab1LLJwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:52:12 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 04:52:12 EST
From: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds: mc13783: fix off-by-one for checking num_leds
Date: Mon, 12 Dec 2011 10:45:28 +0100
Message-ID: <2041769.UEZ0VI7T2U@laptop>
Organization: EPFL - STI - LSRO1
User-Agent: KMail/4.7.3 (Linux/3.1.4-1.fc16.x86_64; KDE/4.7.3; x86_64; ; )
In-Reply-To: <1323501296.2539.2.camel@phoenix>
References: <1323501296.2539.2.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 10 décembre 2011 15:14:56 Axel Lin a écrit :
> The LED id is begin from 0.
> Thus the maximum number of leds should be MC13783_LED_MAX + 1.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/leds/leds-mc13783.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
> index c61e8c4..8bc4915 100644
> --- a/drivers/leds/leds-mc13783.c
> +++ b/drivers/leds/leds-mc13783.c
> @@ -275,7 +275,7 @@ static int __devinit mc13783_led_probe(struct
> platform_device *pdev) return -ENODEV;
>  	}
> 
> -	if (pdata->num_leds < 1 || pdata->num_leds > MC13783_LED_MAX) {
> +	if (pdata->num_leds < 1 || pdata->num_leds > (MC13783_LED_MAX + 1)) {
>  		dev_err(&pdev->dev, "Invalid led count %d\n", pdata->num_leds);
>  		return -EINVAL;
>  	}

Acked-by: Philippe Retornaz <philippe.retornaz@epfl.ch>

Thanks ! 

Philippe

