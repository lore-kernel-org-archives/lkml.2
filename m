Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1FCNXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:23:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1FCNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:23:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/4] ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
Date: Fri, 3 Jun 2011 13:23:00 +0000
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1+; KDE/4.6.3; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, kernel@pengutronix.de, olof@lixom.net
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org> <1306985632-18820-4-git-send-email-shawn.guo@linaro.org> <BANLkTikUnDN81f3cv-buqsKUgdqXsRcYhQ@mail.gmail.com>
In-Reply-To: <BANLkTikUnDN81f3cv-buqsKUgdqXsRcYhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201106031323.01024.arnd@arndb.de>
X-Provags-ID: V02:K0:w19ShM5OasI6W1bytTKJUeEz1rNk0O49kuoNAy6ujfw
 LnADoOsxUoG+tMwz3OXfyMh3hf10zhazNnOBYbEEidj5Wv2Y0Y
 f5fMkesbCcWbRUCE00Rajde2Tew52zCzPicF7qSPr4kUFA3V8g
 MO6Vxt3ATApSKaL1GTXOLFNHN/xU20svmOxT3+/WBzhrnTWMwU
 fsiW6kKBb5FCB/EeO2ClQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 11:54:14 Fabio Estevam wrote:
> On Thu, Jun 2, 2011 at 12:33 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> ...
> 
> > +void __init imx1_soc_init(void)
> > +{
> > +       mxc_register_gpio(0, MX1_GPIO1_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTA, 0);
> > +       mxc_register_gpio(1, MX1_GPIO2_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTB, 0);
> > +       mxc_register_gpio(2, MX1_GPIO3_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTC, 0);
> > +       mxc_register_gpio(3, MX1_GPIO4_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTD, 0);
> 
> By just reading the function names like "imx1_soc_init" we have really
> no clue of what it actually does.
> 
> "soc_init" is too vague IMHO. Could´t you change the names to
> something like "imx1_gpio_init" or "imx1_gpio_register".
> 
> It would be nice at least are dealing with gpio.

Olof and I asked Shawn to do it specifically this way, so we have a place
where more SOC specific initialization can be added without having to
change every single board file.

	Arnd
