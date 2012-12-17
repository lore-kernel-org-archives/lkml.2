Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2LQNwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:52:03 -0500
Received: from antcom.de ([188.40.178.216]:47018 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab2LQNwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:52:01 -0500
Message-ID: <50CF237E.5020409@antcom.de>
Date: Mon, 17 Dec 2012 14:51:58 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: rmallon@gmail.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca, daniel-gl@gmx.net,
        sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com> <50CF1EF1.2070601@antcom.de>
In-Reply-To: <50CF1EF1.2070601@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

On 12/17/2012 02:32 PM, Roland Stigge wrote:
> And I guess Russell is right: If possible, we should write outputs
> simultaneously via ODSR (plus OWER/OWDR/OWSR) instead of separate set/clear.
> 
> I wonder if we need to save/restore the state of OWSR at every write
> operation or if we need/can cache it. Assuming that block GPIO are the
> only code in the kernel that manipulates ODSR.

Can you please test the following:

+static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
+{
+       struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
+       void __iomem *pio = at91_gpio->regbase;
+
+       __raw_writel(~mask, pio + PIO_OWDR);
+       __raw_writel(mask, pio + PIO_OWER);
+       __raw_writel(val, pio + PIO_ODSR);
+}

Would caching OWSR be a significant speedup here?

Thanks in advance,

Roland
