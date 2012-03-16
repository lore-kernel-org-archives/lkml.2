Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422694Ab2CPKnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:43:37 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:56068 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422660Ab2CPKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:43:36 -0400
Message-ID: <4F631953.1090701@ge.com>
Date: Fri, 16 Mar 2012 10:43:31 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vme: fix section mismatches in linux-next 20120314
References: <1331801439-30038-1-git-send-email-dev@snitselaar.org>
In-Reply-To: <1331801439-30038-1-git-send-email-dev@snitselaar.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2012 10:43:33.0463 (UTC) FILETIME=[A2619E70:01CD0361]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/03/12 08:50, Gerard Snitselaar wrote:
> pio2_gpio_init() annotated with __init, but called by pio2_probe()
> which is annotated __devinit. pio2_gpio_exit() is annotated __exit,
> but is called by pio2_probe() and by pio2_remove() which is annotated
> __devexit.
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

I was just about to ack that and realised that Greg's already applied it :-)

Good catch, thanks,

Martyn

> ---
>  drivers/staging/vme/devices/vme_pio2.h      |    4 ++--
>  drivers/staging/vme/devices/vme_pio2_gpio.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_pio2.h b/drivers/staging/vme/devices/vme_pio2.h
> index 3c59313..72d9ce0 100644
> --- a/drivers/staging/vme/devices/vme_pio2.h
> +++ b/drivers/staging/vme/devices/vme_pio2.h
> @@ -243,7 +243,7 @@ struct pio2_card {
>  int pio2_cntr_reset(struct pio2_card *);
>  
>  int pio2_gpio_reset(struct pio2_card *);
> -int __init pio2_gpio_init(struct pio2_card *);
> -void __exit pio2_gpio_exit(struct pio2_card *);
> +int __devinit pio2_gpio_init(struct pio2_card *);
> +void pio2_gpio_exit(struct pio2_card *);
>  
>  #endif /* _VME_PIO2_H_ */
> diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
> index dc837de..8584849 100644
> --- a/drivers/staging/vme/devices/vme_pio2_gpio.c
> +++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
> @@ -187,7 +187,7 @@ int pio2_gpio_reset(struct pio2_card *card)
>  	return 0;
>  }
>  
> -int __init pio2_gpio_init(struct pio2_card *card)
> +int __devinit pio2_gpio_init(struct pio2_card *card)
>  {
>  	int retval = 0;
>  	char *label;
> @@ -220,7 +220,7 @@ int __init pio2_gpio_init(struct pio2_card *card)
>  	return retval;
>  };
>  
> -void __exit pio2_gpio_exit(struct pio2_card *card)
> +void pio2_gpio_exit(struct pio2_card *card)
>  {
>  	const char *label = card->gc.label;
>  


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
