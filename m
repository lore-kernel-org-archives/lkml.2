Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2DQTbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:31:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52948 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2DQTbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F8D8365.3020002@flameeyes.eu>
References: <4F8C7839.6060104@flameeyes.eu>
	<CACRpkdaOSSA8PuTSQ4utp9JHKbBiz+iWfuPn=2WyojZxsR5a3A@mail.gmail.com>
	<4F8D8365.3020002@flameeyes.eu>
Date: Tue, 17 Apr 2012 21:31:51 +0200
Message-ID: <CACRpkdYD7b36-of+RMGKG=1t1gr+3gz_BuimqGK1egH2t_Oybw@mail.gmail.com>
Subject: Re: [RFC] IT87xx GPIO and other drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Diego_Elio_Petten=F2?= <flameeyes@flameeyes.eu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        guillaume ligneul <guillaume.ligneul@oselis.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 4:51 PM, Diego Elio Pettenò
<flameeyes@flameeyes.eu> wrote:

> Does that mean that when the user enables the MFD, they get gpio,
> pinctrl and watchdog at once, or should it still have multiple Kconfig
> entries which select it?

No I just meant that the driver file in drivers/pinctrl/pinctrl-it87.c should
implement pinctrl, gpiolib (struct gpio_chip) and any GPIO
IRQs (struct irq_chip) in that one and the same file.

The MFD device will spawn cells/children as usual for HWMON and
other stuff, but the cell named "pinctrl-it87" (or however you
name it) should take care of all the pinctrl and GPIO stuff.

Yours,
Linus Walleij
