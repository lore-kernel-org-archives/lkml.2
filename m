Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0FXMLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:11:13 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:43338 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab0FXMLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:11:12 -0400
Date: Thu, 24 Jun 2010 17:41:00 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/6] mfd/stmpexxx: fix stmpe811 enable hook
Message-ID: <20100624121059.GA26189@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-6-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1277378021-16802-6-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 13:13:40 +0200, Luotao Fu wrote:
> Fix the stmpe811 enable hook so that we can activate the needed clocks for the
> touchscreen controller.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> ---
>  drivers/mfd/stmpe-devices.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
> index 3e21c26..25941ea 100644
> --- a/drivers/mfd/stmpe-devices.c
> +++ b/drivers/mfd/stmpe-devices.c
> @@ -117,8 +117,9 @@ static int stmpe811_enable(struct stmpe *stmpe, unsigned int blocks,
>  	if (blocks & STMPE_BLOCK_ADC)
>  		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
>  
> -	if (blocks & STMPE_BLOCK_KEYPAD)
> -		mask |= STMPE811_SYS_CTRL2_TSC_OFF;
> +	if (blocks & STMPE_BLOCK_TOUCHSCREEN)
> +		mask |= STMPE811_SYS_CTRL2_ADC_OFF
> +			| STMPE811_SYS_CTRL2_TSC_OFF;

The KEYPAD -> TOUCHSCREEN fix is fine, but for the ADC, wouldn't it be
better to pass in STMPE_BLOCK_ADC in your stmpe_enable() call instead?
You wouldn't need to add another call, you can just pass in
(STMPE_BLOCK_TOUCHSCREEN | STMPE_BLOCK_ADC) as the argument.

Rabin
