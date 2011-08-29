Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1H2TBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:01:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50729 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1H2TBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:01:47 -0400
Date: Mon, 29 Aug 2011 13:01:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] gpiolib: add another might_sleep
Message-ID: <20110829190142.GA17354@ponder.secretlab.ca>
References: <1297977533-17794-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297977533-17794-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:18:53PM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpiolib.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 5fc5e2d..2c9f814 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1207,6 +1207,7 @@ int gpio_request(unsigned gpio, const char *label)
>  	if (chip->request) {
>  		/* chip->request may sleep */
>  		spin_unlock_irqrestore(&gpio_lock, flags);
> +		might_sleep_if(chip->can_sleep);
>  		status = chip->request(chip, gpio - chip->base);
>  		spin_lock_irqsave(&gpio_lock, flags);
>  
> -- 
> 1.7.2.3
> 
