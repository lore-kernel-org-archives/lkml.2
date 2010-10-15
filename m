Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0JONSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:18:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33880 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab0JONSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:18:53 -0400
Date: Fri, 15 Oct 2010 15:18:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/mc13xxx: don't open code kasprintf
Message-ID: <20101015131848.GA16893@pengutronix.de>
References: <1286731711-17865-1-git-send-email-segooon@gmail.com> <1286739586-32745-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286739586-32745-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

would you mind to take this patch (or squash it into
0c9b33e5a23e2053165c9e30ffff3b3a3cf1b2b8)?

Thanks
Uwe

On Sun, Oct 10, 2010 at 09:39:46PM +0200, Uwe Kleine-König wrote:
> This fixes an off by one error noticed by Vasiliy Kulikov en passant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mfd/mc13xxx-core.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 93258ad..b763b8c 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -687,7 +687,6 @@ EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
>  static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
>  		const char *format, void *pdata, size_t pdata_size)
>  {
> -	char buf[30];
>  	const char *name = mc13xxx_get_chipname(mc13xxx);
>  
>  	struct mfd_cell cell = {
> @@ -695,11 +694,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
>  		.data_size = pdata_size,
>  	};
>  
> -	/* there is no asnprintf in the kernel :-( */
> -	if (snprintf(buf, sizeof(buf), format, name) > sizeof(buf))
> -		return -E2BIG;
> -
> -	cell.name = kmemdup(buf, strlen(buf) + 1, GFP_KERNEL);
> +	cell.name = kasprintf(GFP_KERNEL, format, name);
>  	if (!cell.name)
>  		return -ENOMEM;
>  
> -- 
> 1.7.2.3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
