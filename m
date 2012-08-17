Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2HQJKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:10:32 -0400
Received: from antcom.de ([188.40.178.216]:38550 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab2HQJKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:10:24 -0400
Message-ID: <502E0A7B.1040607@antcom.de>
Date: Fri, 17 Aug 2012 11:10:19 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de>
In-Reply-To: <502D1CC2.9020901@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/16/2012 06:16 PM, Roland Stigge wrote:
> On 08/16/2012 06:05 PM, Sebastian Andrzej Siewior wrote:
>>> --- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
>>> +++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
>>> @@ -2987,14 +2986,14 @@ static irqreturn_t lpc32xx_usb_vbus_irq(
>>>       return IRQ_HANDLED;
>>>   }
>>>
>>> -static int lpc32xx_start(struct usb_gadget_driver *driver,
>>> -             int (*bind)(struct usb_gadget *))
>>> +static int lpc32xx_start(struct usb_gadget *gadget,
>>> +             struct usb_gadget_driver *driver)
>>>   {
>>> -    struct lpc32xx_udc *udc =&controller;
>>
>> I assume controller is a global var created at probe time and could be
>> removed now, right?
> 
> Yes!

Well ;-) looking more closely into it, I'd like to keep it for now: It
is a more complex statically pre-initialized struct, finally being used
in probe() for more dynamic initialization, and it ends up being used by
many other functions, including lpc32xx_start() where accessing it now
via container_of() is just a bit more elegant than a direct &controller
of the global variable.

Also, since this device is a single controller in the LPC32xx SoC, I
would keep it until some other silicon uses several of this IP core
(which I doubt), at which point we would probably still keep the (global
static) controller and memcpy it to a dynamically allocated struct.

Sounds reasonable?

Thanks,

Roland
