Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0HBKBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:01:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:54600 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0HBKBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:01:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="643881772"
Date: Mon, 2 Aug 2010 12:01:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] mfd/mc13783: new function exposing flags
Message-ID: <20100802100142.GB3334@sortiz-mobl>
References: <1280740459-11500-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1280740459-11500-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Mon, Aug 02, 2010 at 11:14:17AM +0200, Uwe Kleine-König wrote:
> This is needed for the mc13783-adc driver to decide if a touch screen is
> connected.  If so some channels are not available as generic hwmon inputs.
Looks good to me, applied to my for-next branch.

Now that we're at it, could we then move mc13783-private.h from include/linux/
to driver/mfd ?

Cheers,
Samuel.


> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mfd/mc13783-core.c  |    6 ++++++
>  include/linux/mfd/mc13783.h |    2 ++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
> index ead84e4..a4fa191 100644
> --- a/drivers/mfd/mc13783-core.c
> +++ b/drivers/mfd/mc13783-core.c
> @@ -226,6 +226,12 @@ int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
>  }
>  EXPORT_SYMBOL(mc13783_reg_rmw);
>  
> +int mc13783_get_flags(struct mc13783 *mc13783)
> +{
> +	return mc13783->flags;
> +}
> +EXPORT_SYMBOL(mc13783_get_flags);
> +
>  int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
>  {
>  	int ret;
> diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
> index 4a894f6..0fa44fb 100644
> --- a/include/linux/mfd/mc13783.h
> +++ b/include/linux/mfd/mc13783.h
> @@ -21,6 +21,8 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val);
>  int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
>  		u32 mask, u32 val);
>  
> +int mc13783_get_flags(struct mc13783 *mc13783);
> +
>  int mc13783_irq_request(struct mc13783 *mc13783, int irq,
>  		irq_handler_t handler, const char *name, void *dev);
>  int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
