Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2DGBxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:53:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43180 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab2DGBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:51:54 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Fix uninitialized variable bit in adp5588_irq_handler
To: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Linus Walleij <linus.walleij@stericsson.com>
In-Reply-To: <1333715863.17459.4.camel@phoenix>
References: <1333715863.17459.4.camel@phoenix>
Date: Fri, 06 Apr 2012 15:48:11 -0700
Message-Id: <20120406224811.5630A3E0F0A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2012 20:37:43 +0800, Axel Lin <axel.lin@gmail.com> wrote:
> The variable 'bit' is uninitialized in the first iteration of for loop. Fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, and will merge for v3.4.  THanks.

g.

> ---
>  drivers/gpio/gpio-adp5588.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-adp5588.c b/drivers/gpio/gpio-adp5588.c
> index 9ad1703..ae5d7f1 100644
> --- a/drivers/gpio/gpio-adp5588.c
> +++ b/drivers/gpio/gpio-adp5588.c
> @@ -252,7 +252,7 @@ static irqreturn_t adp5588_irq_handler(int irq, void *devid)
>  		if (ret < 0)
>  			memset(dev->irq_stat, 0, ARRAY_SIZE(dev->irq_stat));
>  
> -		for (bank = 0; bank <= ADP5588_BANK(ADP5588_MAXGPIO);
> +		for (bank = 0, bit = 0; bank <= ADP5588_BANK(ADP5588_MAXGPIO);
>  			bank++, bit = 0) {
>  			pending = dev->irq_stat[bank] & dev->irq_mask[bank];
>  
> -- 
> 1.7.5.4
> 
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
