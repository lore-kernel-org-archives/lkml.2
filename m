Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2ECDff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:35:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48221 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2ECDfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <4FA19AE9.104@lwfinger.net>
References: <CAFDqYy3OCmRHFR05=iQs-Q1hc5OMwZFiVkDbVnv5KXPA5pxfQA@mail.gmail.com>
	<CAFDqYy03M7aZBzz30fT590YsLvZsm6JorXBGZ1CwJg2Qp01UOQ@mail.gmail.com>
	<4FA19AE9.104@lwfinger.net>
Date: Thu, 3 May 2012 09:35:32 +0600
Message-ID: <CAFDqYy3NDWRZuKQU3TrL8q8jzKo_c3wDiVZdQ=7W0KnHWUVcTA@mail.gmail.com>
Subject: Re: staging/rtl8712: unhandled default case in SwLedOn function.
From: joseph daniel <josephdanielwalter@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ali Bahar <ali@internetdog.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 2:36 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/02/2012 03:12 PM, joseph daniel wrote:
>>
>> On Thu, May 3, 2012 at 2:10 AM, joseph daniel
>> <josephdanielwalter@gmail.com>  wrote:
>>>
>>> Hi kernel developers,
>>>
>>> In the function SwLedOn in rtl8712_led.c, we put the bLedOn = true,
>>> even if its a default case. may be we need to return? or BUG()?.
>>>
>>> the code listing is:
>>>
>>> if ((padapter->bSurpriseRemoved == true) ||
>>>        (padapter->bDriverStopped == true))
>>>        return;
>>>    LedCfg = r8712_read8(padapter, LEDCFG);
>>>    switch (pLed->LedPin) {
>>>    case LED_PIN_GPIO0:
>>>        break;
>>>    case LED_PIN_LED0:
>>>        /* SW control led0 on.*/
>>>        r8712_write8(padapter, LEDCFG, LedCfg&0xf0);
>>>        break;
>>>    case LED_PIN_LED1:
>>>        /* SW control led1 on.*/
>>>        r8712_write8(padapter, LEDCFG, LedCfg&0x0f);
>>>        break;
>>>    default:
>>
>> /* at this point of the code */
>>>
>>>       /* break; */
>>
>>          return; /* or */
>>          /* BUG(); */ /*since we may not be getting into here */
>>>
>>>    }
>>>    pLed->bLedOn = true;
>>>
>
> This should do:
>
> Index: staging/drivers/staging/rtl8712/rtl8712_led.c
> ===================================================================
> --- staging.orig/drivers/staging/rtl8712/rtl8712_led.c
> +++ staging/drivers/staging/rtl8712/rtl8712_led.c
> @@ -137,7 +137,8 @@ static void SwLedOn(struct _adapter *pad
>
>                r8712_write8(padapter, LEDCFG, LedCfg&0x0f);
>                break;
>        default:
> -               break;
> +               WARN_ONCE(1, "Default branch taken in %s\n", __func__);
> +               return;
>        }
>        pLed->bLedOn = true;
>  }
>
> If you agree, then I will push the patch to Greg.
>
Agreed. Thanks Greg and Larry.
Acked-by: josephdanielwalter@gmail.com

> Larry


Thanks,
