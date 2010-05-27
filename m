Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0E0VJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:09:07 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:35125 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754592Ab0E0VJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:09:05 -0400
Message-ID: <4BFEDF6D.3090100@bluewatersys.com>
Date: Fri, 28 May 2010 09:09:01 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Robert Emanuele <rob@emanuele.us>
CC: Wolfram Sang <w.sang@pengutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-kernel@vger.kernel.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-i2c@vger.kernel.org
Subject: Re: Controlling Driver Load Order
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>	<AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>	<20100526235246.GA31068@pengutronix.de>	<AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com>	<20100527041358.GA14070@pengutronix.de> <AANLkTilKUfcYsPqr5kXlONJQAFCaE8D8U9ltQybIzCPu@mail.gmail.com>
In-Reply-To: <AANLkTilKUfcYsPqr5kXlONJQAFCaE8D8U9ltQybIzCPu@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Emanuele wrote:
> Hi Wolfram,
> 
> I am using the i2c-gpio.c driver, not the i2c-at91 driver.  The Atmel
> folks have expressed concerns over their i2c silicon and wrote a gpio
> version.
> 
> Anyway, I better understand the subsys_initcall now and applied that
> to the i2c-gpio and my i2c chip driver.  That worked perfectly for my
> issue.  I'd be happy to return a patch of this.  Would be this the
> sort of thing that would benefit from a config option?  Something
> like:
> 
> #if defined(CONFIG_EARLY_i2C_GPIO)
> subsys_initcall(i2c_gpio_init);
> #else
> module_init(i2c_gpio_init);
> #endif

Looks like this has already been done:
http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg03056.html

There was a discussion a while back to make all of the embedded i2c
busses be subsys_initcall since i2c is often a system bus on embedded
devices. Looks the i2c_gpio driver got missed the first time round.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
