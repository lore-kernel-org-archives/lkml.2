Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab2HPQFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:05:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:45089 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab2HPQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:05:33 -0400
Message-ID: <502D1A49.20603@linutronix.de>
Date: Thu, 16 Aug 2012 18:05:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1345131276-28982-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 05:34 PM, Roland Stigge wrote:
> --- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
> +++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
> @@ -2987,14 +2986,14 @@ static irqreturn_t lpc32xx_usb_vbus_irq(
>   	return IRQ_HANDLED;
>   }
>
> -static int lpc32xx_start(struct usb_gadget_driver *driver,
> -			 int (*bind)(struct usb_gadget *))
> +static int lpc32xx_start(struct usb_gadget *gadget,
> +			 struct usb_gadget_driver *driver)
>   {
> -	struct lpc32xx_udc *udc =&controller;

I assume controller is a global var created at probe time and could be
removed now, right?

> -	int retval, i;
> +	struct lpc32xx_udc *udc =
> +		container_of(gadget, struct lpc32xx_udc, gadget);
> +	int i;


Sebastian
