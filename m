Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2LPNLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:11:24 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54158 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2LPNLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:11:23 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 14:11:22 +0100
X-Google-Sender-Auth: Wz_XHp3ug3Q0A-gjWTK9cjpHX9E
Message-ID: <CAMuHMdWqb_OxBV=8K_NAN_rgC6Tq9URbwmHTu2LgojWjYxEJUA@mail.gmail.com>
Subject: redefinition of devm_gpio_request
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On current linus/HEAD, m68k allmodconfig gives:

drivers/gpio/devres.c:52: error: redefinition of ‘devm_gpio_request’
include/linux/gpio.h:99: error: previous definition of
‘devm_gpio_request’ was here
drivers/gpio/devres.c:82: error: redefinition of ‘devm_gpio_request_one’
include/linux/gpio.h:111: error: previous definition of
‘devm_gpio_request_one’ was here
drivers/gpio/devres.c:114: error: redefinition of ‘devm_gpio_free’
include/linux/gpio.h:129: error: previous definition of
‘devm_gpio_free’ was here
make[5]: *** [drivers/gpio/devres.o] Error 1

The !CONFIG_GENERIC_GPIO dummy definitions in include/linux/gpio.h conflict
with the real ones in drivers/gpio/devres.c.
Should devres.c really be compiled if !CONFIG_GENERIC_GPIO?

In 3.7, this doesn't show up as CONFIG_GPIOLIB is not enabled. I assume
it gets selected by some driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
