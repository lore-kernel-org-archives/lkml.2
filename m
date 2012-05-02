Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2EBUUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:20:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54029 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2EBUUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:20:36 -0400
Date: Wed, 2 May 2012 13:20:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Ali Bahar <ali@internetdog.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: staging/rtl8712: unhandled default case in SwLedOn function.
Message-ID: <20120502202031.GA26628@kroah.com>
References: <CAFDqYy3OCmRHFR05=iQs-Q1hc5OMwZFiVkDbVnv5KXPA5pxfQA@mail.gmail.com>
 <CAFDqYy03M7aZBzz30fT590YsLvZsm6JorXBGZ1CwJg2Qp01UOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFDqYy03M7aZBzz30fT590YsLvZsm6JorXBGZ1CwJg2Qp01UOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 02:12:39AM +0600, joseph daniel wrote:
> On Thu, May 3, 2012 at 2:10 AM, joseph daniel
> <josephdanielwalter@gmail.com> wrote:
> > Hi kernel developers,
> >
> > In the function SwLedOn in rtl8712_led.c, we put the bLedOn = true,
> > even if its a default case. may be we need to return? or BUG()?.
> >
> > the code listing is:
> >
> > if ((padapter->bSurpriseRemoved == true) ||
> >        (padapter->bDriverStopped == true))
> >        return;
> >    LedCfg = r8712_read8(padapter, LEDCFG);
> >    switch (pLed->LedPin) {
> >    case LED_PIN_GPIO0:
> >        break;
> >    case LED_PIN_LED0:
> >        /* SW control led0 on.*/
> >        r8712_write8(padapter, LEDCFG, LedCfg&0xf0);
> >        break;
> >    case LED_PIN_LED1:
> >        /* SW control led1 on.*/
> >        r8712_write8(padapter, LEDCFG, LedCfg&0x0f);
> >        break;
> >    default:
> /* at this point of the code */
> >       /* break; */
>          return; /* or */
>          /* BUG(); */ /*since we may not be getting into here */

Never crash the kernel in a driver, that's just rude.  Error out
properly if something unexpected happens.

thanks,

greg k-h
