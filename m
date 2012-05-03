Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2ECHXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:23:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18066 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2ECHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:23:47 -0400
Date: Thu, 3 May 2012 10:26:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: joseph daniel <josephdanielwalter@gmail.com>, devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: staging/rtl8712: unhandled default case in SwLedOn function.
Message-ID: <20120503072652.GA13252@mwanda>
References: <CAFDqYy3OCmRHFR05=iQs-Q1hc5OMwZFiVkDbVnv5KXPA5pxfQA@mail.gmail.com>
 <CAFDqYy03M7aZBzz30fT590YsLvZsm6JorXBGZ1CwJg2Qp01UOQ@mail.gmail.com>
 <4FA19AE9.104@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA19AE9.104@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This should do:
> 
> Index: staging/drivers/staging/rtl8712/rtl8712_led.c
> ===================================================================
> --- staging.orig/drivers/staging/rtl8712/rtl8712_led.c
> +++ staging/drivers/staging/rtl8712/rtl8712_led.c
> @@ -137,7 +137,8 @@ static void SwLedOn(struct _adapter *pad
>  		r8712_write8(padapter, LEDCFG, LedCfg&0x0f);
>  		break;
>  	default:
> -		break;
> +		WARN_ONCE(1, "Default branch taken in %s\n", __func__);
> +		return;
>  	}
>  	pLed->bLedOn = true;
>  }
> 

Don't just reflexively add extra debug code.

In this case pLed->LedPin is either LED_PIN_LED0 or LED_PIN_LED1.
The LED_PIN_GPIO0 and default cases are never used.  Even if it were
I think we would want to set pLed->bLedOn = true in the default
case.

The code is ugly as pants, but it works fine as is.

regards,
dan carpenter

