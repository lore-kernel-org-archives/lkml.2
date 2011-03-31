Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab1CaVR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:17:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab1CaVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:17:55 -0400
Date: Thu, 31 Mar 2011 15:17:52 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] gpio: pch_gpio: Fix output value of
 pch_gpio_direction_output()
Message-ID: <20110331211752.GC437@ponder.secretlab.ca>
References: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
 <1301065440-2418-1-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301065440-2418-1-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 10:04:00AM -0500, Peter Tyser wrote:
> The pch_gpio_direction_output() function was missing a write to set the
> desired output value.  The function would properly set the GPIO
> direction, but not the output value.  The value would have to manually
> be set with a follow up call to pch_gpio_set().
> 
> Add the missing write so that pch_gpio_direction_output() sets both the
> GPIO direction and value.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Cc: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks.

g.
> ---
> Just noticed this driver has the same bug.  This file looks nearly identical
> to ml_ioh_gpio.c.  They could likely be combined with minimal effort.
> 
>  drivers/gpio/pch_gpio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index c59d953..fa52862 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
> @@ -105,6 +105,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
>  		reg_val |= (1 << nr);
>  	else
>  		reg_val &= ~(1 << nr);
> +	iowrite32(reg_val, &chip->reg->po);
>  
>  	mutex_unlock(&chip->lock);
>  
> -- 
> 1.7.0.4
> 
