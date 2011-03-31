Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab1CaVSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:18:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab1CaVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:18:11 -0400
Date: Thu, 31 Mar 2011 15:18:08 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH] gpio: ml_ioh_gpio: Fix output value of
 ioh_gpio_direction_output()
Message-ID: <20110331211808.GD437@ponder.secretlab.ca>
References: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 06:17:14PM -0500, Peter Tyser wrote:
> The ioh_gpio_direction_output() function was missing a write to set the
> desired output value.  The function would properly set the GPIO
> direction, but not the output value.  The value would have to manually
> be set with a follow up call to ioh_gpio_set().
> 
> Add the missing write so that ioh_gpio_direction_output() sets both the
> GPIO direction and value.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Cc: tomoya-linux@dsn.okisemi.com
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
> This is untested - just noticed it while working on an unrelated change.  An
> ack or tested-by from someone with real hardware would be appreciated.

Applied, thanks.

g.

> 
>  drivers/gpio/ml_ioh_gpio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/ml_ioh_gpio.c
> index cead8e6..7a0423c 100644
> --- a/drivers/gpio/ml_ioh_gpio.c
> +++ b/drivers/gpio/ml_ioh_gpio.c
> @@ -116,6 +116,7 @@ static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
>  		reg_val |= (1 << nr);
>  	else
>  		reg_val &= ~(1 << nr);
> +	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
>  
>  	mutex_unlock(&chip->lock);
>  
> -- 
> 1.7.0.4
> 
