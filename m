Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0FXMf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:35:56 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:43235 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332Ab0FXMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:35:54 -0400
Date: Thu, 24 Jun 2010 18:05:42 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/6 V2] mfd/stmpexxx: fix stmpe811 enable hook
Message-ID: <20100624123542.GC26189@bnru02.bnr.st.com>
References: <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
 <1277382466-23603-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1277382466-23603-1-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 14:27:46 +0200, Luotao Fu wrote:
> diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
> index 3e21c26..ded9dcb 100644
> --- a/drivers/mfd/stmpe-devices.c
> +++ b/drivers/mfd/stmpe-devices.c
> @@ -117,8 +117,8 @@ static int stmpe811_enable(struct stmpe *stmpe, unsigned int blocks,
>  	if (blocks & STMPE_BLOCK_ADC)
>  		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
>  
> -	if (blocks & STMPE_BLOCK_KEYPAD)
> -		mask |= STMPE811_SYS_CTRL2_TSC_OFF;
> +	if (blocks & STMPE_BLOCK_TOUCHSCREEN)
> +		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
>  

You shouldn't be changing TSC_OFF to ADC_OFF, since you're making this
for the touchscreen.

Rabin
