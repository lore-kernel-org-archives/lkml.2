Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1LMSF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:05:57 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35504 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1LMSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:05:52 -0500
Date: Tue, 13 Dec 2011 11:05:45 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Feng Tang <feng.tang@intel.com>
Cc: linus.walleij@linaro.org, tomoya-linux@dsn.lapis-semi.com,
        linux-kernel@vger.kernel.org, joel.clark@intel.com,
        ying.huang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] gpio-ml-ioh: fix a bug in the interrupt handler
Message-ID: <20111213180545.GC4871@ponder.secretlab.ca>
References: <1323791630-4125-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323791630-4125-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:53:49PM +0800, Feng Tang wrote:
> GPIO's irq action's dev_id is set to the first struct ioh_gpio chip,
> so when loop checking the 8 chips, the "chip" should be changed
> according.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-ml-ioh.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index ea8e738..92b6f51 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -339,7 +339,7 @@ static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
>  	int i, j;
>  	int ret = IRQ_NONE;
>  
> -	for (i = 0; i < 8; i++) {
> +	for (i = 0; i < 8; i++, chip++) {
>  		reg_val = ioread32(&chip->reg->regs[i].istatus);
>  		for (j = 0; j < num_ports[i]; j++) {
>  			if (reg_val & BIT(j)) {
> -- 
> 1.7.1
> 
