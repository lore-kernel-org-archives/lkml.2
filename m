Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2HTIQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:16:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:32846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2HTIQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:16:37 -0400
Message-ID: <5031F262.3090103@linutronix.de>
Date: Mon, 20 Aug 2012 10:16:34 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH 3/3] usb: gadget: lpc32xx_udc: Support multiple controllers
References: <1345450306-4996-1-git-send-email-stigge@antcom.de> <1345450306-4996-3-git-send-email-stigge@antcom.de>
In-Reply-To: <1345450306-4996-3-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 10:11 AM, Roland Stigge wrote:
> --- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
> +++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
> @@ -2608,10 +2608,9 @@ static void nop_release(struct device *d
>   	/* nothing to free */
>   }
>
> -static struct lpc32xx_udc controller = {
> +static struct lpc32xx_udc controller_template = {

make it const please.

>   	.gadget = {
>   		.ops	=&lpc32xx_udc_ops,
> -		.ep0	=&controller.ep[0].ep,
>   		.name	= driver_name,
>   		.dev	= {
>   			.init_name = "gadget",

Sebastian
