Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0KKPoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:44:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45191 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0KKPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:44:09 -0500
Date: Thu, 11 Nov 2010 16:44:07 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fabio Estevam <fabioestevam@yahoo.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        s.hauer@pengutronix.de
Subject: Re: [PATCH] mfd: check for NULL platform data
Message-ID: <20101111154407.GC18358@pengutronix.de>
References: <805862.49452.qm@web51006.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <805862.49452.qm@web51006.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Thu, Nov 11, 2010 at 06:58:14AM -0800, Fabio Estevam wrote:
> Avoid kernel crash if platform data is NULL.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/mc13xxx-core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index a2ac2ed..b4d6bb1 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -757,6 +757,9 @@ err_revision:
>  
>  	mc13xxx_unlock(mc13xxx);
>  
> +	if (pdata == NULL)
> +		return 0;
> +
I'm not sure it's really needed to catch this error.  Not passing pdata
isn't sensible and then maybe failing with a bang is better than
handling silently.

And if you want to break probing, do you really want to return 0, i.e.
let the binding succeed?  IMHO (if you really want to handle pdata ==
NULL) you should fail before allocating the private data with
-ESOMETHINGSENSIBLE.

Thanks,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
