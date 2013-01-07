Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3AGQZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:25:44 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:15556 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3AGQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:25:42 -0500
Message-ID: <50EAF716.709@atmel.com>
Date: Mon, 7 Jan 2013 17:25:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 22/25] usb/at91_udc: don't use [delayed_]work_pending()
References: <1356141435-17340-1-git-send-email-tj@kernel.org> <1356141435-17340-23-git-send-email-tj@kernel.org>
In-Reply-To: <1356141435-17340-23-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 02:57 AM, Tejun Heo :
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from at91_udc.  Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  drivers/usb/gadget/at91_udc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
> index f4a21f6..e81d8a2 100644
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -1621,8 +1621,7 @@ static void at91_vbus_timer(unsigned long data)
>  	 * bus such as i2c or spi which may sleep, so schedule some work
>  	 * to read the vbus gpio
>  	 */
> -	if (!work_pending(&udc->vbus_timer_work))
> -		schedule_work(&udc->vbus_timer_work);
> +	schedule_work(&udc->vbus_timer_work);
>  }
>  
>  static int at91_start(struct usb_gadget *gadget,
> 


-- 
Nicolas Ferre
