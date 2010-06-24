Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0FXNJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:09:52 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:57128 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810Ab0FXNJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:09:51 -0400
Date: Thu, 24 Jun 2010 18:39:43 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 4/6] mfd/stmpexxx: change touchscreen irq
Message-ID: <20100624130942.GG26189@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-5-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1277378021-16802-5-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 13:13:39 +0200, Luotao Fu wrote:
> the stmpe touchscreen driver uses fifo threshold irq to trigger data fetching.
> The touch_det irq bit is only used while polling for release. Change the
> platform resource and the irq definition in the variant block.
> ---
>  drivers/mfd/stmpe-devices.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
> index fa6934d..3e21c26 100644
> --- a/drivers/mfd/stmpe-devices.c
> +++ b/drivers/mfd/stmpe-devices.c
> @@ -59,17 +59,11 @@ static struct mfd_cell stmpe_keypad_cell = {
>  
>  static struct resource stmpe_ts_resources[] = {
>  	{
> -		.name	= "TOUCH_DET",
> +		.name	= "FIFO_TH",
>  		.start	= 0,
>  		.end	= 0,
>  		.flags	= IORESOURCE_IRQ,
> -	},
> -	{
> -		.name	= "FIFO_TH",
> -		.start	= 1,
> -		.end	= 1,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> +	}
>  };
>  
>  static struct mfd_cell stmpe_ts_cell = {
> @@ -107,7 +101,7 @@ static struct stmpe_variant_block stmpe811_blocks[] = {
>  	},
>  	{
>  		.cell	= &stmpe_ts_cell,
> -		.irq	= STMPE811_IRQ_TOUCH_DET,
> +		.irq	= STMPE811_IRQ_FIFO_TH,
>  		.block	= STMPE_BLOCK_TOUCHSCREEN,
>  	},
>  };

Would it be clearer if you leave this as-is, and instead use
platform_get_irq_byname("FIFO_TH") in the stmpe-ts driver, since I think
the TSC block has a whole bunch of irqs?

Rabin
