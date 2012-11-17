Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2KQWuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:50:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38431 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2KQWuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <1353124734-16803-5-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
	<1353124734-16803-5-git-send-email-cheiny@synaptics.com>
Date: Sat, 17 Nov 2012 23:50:36 +0100
Message-ID: <CACRpkdZ_dAPT6swXqEHor=ka64YPd_7-bZQHGjTAsEeEsvzJWg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/06] input/rmi4: Config files and makefiles
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 4:58 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

> Infrastructure files for configuration and building.
>
>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>

Cut blank line.

> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> Cc: Joeri de Gram <j.de.gram@gmail.com>

(...)
> +++ b/drivers/input/rmi4/Makefile
> @@ -0,0 +1,22 @@
> +obj-$(CONFIG_RMI4_BUS) += rmi_bus.o
> +obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
> +obj-$(CONFIG_RMI4_GENERIC) += rmi_driver.o rmi_f01.o
> +obj-$(CONFIG_RMI4_F11) += rmi_f11.o
> +
> +ccflags-$(CONFIG_RMI4_DEBUG) += -DDEBUG
> +


>From here:

> +ifeq ($(KERNELRELEASE),)
> +
> +# KERNELDIR ?= /home/<AndroidKernelDirectory>
> +PWD := $(shell pwd)
> +
> +.PHONY: build clean
> +
> +build:
> +       $(MAKE) -C $(KERNELDIR) M=$(PWD) modules
> +
> +clean:
> +       rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c
> +
> +endif

This stuff looks weird. Like some local build rule to just rebuild
this part, and the commented-out Android thing is really just
cruft. Just delete all this, keep it in your private delta
if you need it.

Yours,
Linus Walleij
