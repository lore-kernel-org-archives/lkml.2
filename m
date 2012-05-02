Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2EBUKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:10:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45295 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2EBUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:10:19 -0400
MIME-Version: 1.0
Date: Thu, 3 May 2012 02:10:17 +0600
Message-ID: <CAFDqYy3OCmRHFR05=iQs-Q1hc5OMwZFiVkDbVnv5KXPA5pxfQA@mail.gmail.com>
Subject: staging/rtl8712: unhandled default case in SwLedOn function.
From: joseph daniel <josephdanielwalter@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ali Bahar <ali@internetDog.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel developers,

In the function SwLedOn in rtl8712_led.c, we put the bLedOn = true,
even if its a default case. may be we need to return? or BUG()?.

the code listing is:

if ((padapter->bSurpriseRemoved == true) ||
        (padapter->bDriverStopped == true))
        return;
    LedCfg = r8712_read8(padapter, LEDCFG);
    switch (pLed->LedPin) {
    case LED_PIN_GPIO0:
        break;
    case LED_PIN_LED0:
        /* SW control led0 on.*/
        r8712_write8(padapter, LEDCFG, LedCfg&0xf0);
        break;
    case LED_PIN_LED1:
        /* SW control led1 on.*/
        r8712_write8(padapter, LEDCFG, LedCfg&0x0f);
        break;
    default:
        break;
    }
    pLed->bLedOn = true;

Thanks,
Dev.
