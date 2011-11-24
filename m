Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1KXW2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 17:28:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40877 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1KXW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 17:28:34 -0500
Date: Thu, 24 Nov 2011 22:28:36 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: jamie@jamieiles.com, netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91_ether: use gpio_is_valid for phy IRQ line
Message-ID: <20111124222836.GB28582@gallagher>
References: <1322128098-17724-1-git-send-email-jamie@jamieiles.com>
 <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Thu, Nov 24, 2011 at 10:21:14PM +0100, Nicolas Ferre wrote:
> Use the generic gpiolib gpio_is_valid() function to test
> if the phy IRQ line GPIO is actually provided.
> 
> For non-connected or non-existing phy IRQ lines, -EINVAL
> value is used for phy_irq_pin field of struct at91_eth_data.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/net/ethernet/cadence/at91_ether.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
> index 56624d3..a1c4143 100644
> --- a/drivers/net/ethernet/cadence/at91_ether.c
> +++ b/drivers/net/ethernet/cadence/at91_ether.c
> @@ -255,8 +255,7 @@ static void enable_phyirq(struct net_device *dev)
>  	unsigned int dsintr, irq_number;
>  	int status;
>  
> -	irq_number = lp->board_data.phy_irq_pin;
> -	if (!irq_number) {
> +	if (!gpio_is_valid(lp->board_data.phy_irq_pin)) {
>  		/*
>  		 * PHY doesn't have an IRQ pin (RTL8201, DP83847, AC101L),
>  		 * or board does not have it connected.
> @@ -265,6 +264,7 @@ static void enable_phyirq(struct net_device *dev)
>  		return;
>  	}
>  
> +	irq_number = lp->board_data.phy_irq_pin;

Does this need to be:

	irq_number = gpio_to_irq(lp->board_data.phy_irq_pin);

and the same for the other occurrences?  Otherwise this looks like the 
right thing to me.

Jamie
