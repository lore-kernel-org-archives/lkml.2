Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab1GDPov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:44:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56439 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab1GDPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:44:50 -0400
Date: Mon, 4 Jul 2011 09:44:47 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH 1/2] gpio/gpio-generic: read set register for caching if
 available
Message-ID: <20110704154447.GG29977@ponder.secretlab.ca>
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 09:26:22AM +0200, Sebastian Andrzej Siewior wrote:
> The ->data is a shadow copy which is used during the ->set callback in
> order to avoid a read of the register before write.
> If ->reg_set is set then we write to this location therefore we should
> cache that value.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/gpio/gpio-generic.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> index 231714d..9f8b5c6 100644
> --- a/drivers/gpio/gpio-generic.c
> +++ b/drivers/gpio/gpio-generic.c
> @@ -398,7 +398,10 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
>  	if (ret)
>  		return ret;
>  
> -	bgc->data = bgc->read_reg(bgc->reg_dat);
> +	if (bgc->reg_set)
> +		bgc->data = bgc->read_reg(bgc->reg_set);

On most of the gpio controllers that I've seen, the 'set' register
isn't something that you can actually read.  I don't think this is
something that can be done for all gpio controllers.

g.

> +	else
> +		bgc->data = bgc->read_reg(bgc->reg_dat);
>  
>  	return ret;
>  }
> -- 
> 1.7.4.4
> 
