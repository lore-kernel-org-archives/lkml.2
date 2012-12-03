Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2LCJXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:23:25 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:55593 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LCJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:23:22 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 04:23:22 EST
X-manitu-Original-Sender-IP: 88.217.68.6
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50BC6E11.3040203@grandegger.com>
Date: Mon, 03 Dec 2012 10:17:05 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de
Subject: Re: [PATCH 0/6 v8] gpio: Add block GPIO
References: <1354298637-25058-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1354298637-25058-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On 11/30/2012 07:03 PM, Roland Stigge wrote:
> This set of patches adds:
> 
> * Block GPIO API to gpiolib
> * Sysfs support for GPIO API, to provide userland access
> * Device interface for userland access (alternative to sysfs)
> * Devicetree support to instantiate GPIO blocks via DT
> * Example implementations in several gpio drivers since they need
>   special accessor functions for block wise GPIO access
> * Fix for race condition in gpiolib on device creation
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> --
> 
> Changes since v7:
> * Fixed error in API documentation (name arg missing in prototype)
> * Fixed compile error if sysfs is missing: Moved gpio_block_is_output()
>   out of sysfs-ifdef
> * Added error handling to gpio_block_register()
> * Added mask attribute to sysfs (although dev interface exists now)
> 
> Changes since v6:
> * Changed realloc to list handling
> * Added mask to kernel API
> * Added device interface as userspace API
> * Changed sizeof() to BITS_PER_LONG
> * Fixed multiline comment style
> * Documented direction setting by the user
> * Documented order of handled chips in case of multiple chips in one block
> 
> Changes since v5:
> * Documented sysfs: elaborated on "exported" and "values" attributes
> * Documented sysfs: gpiochip is a separate class now
> * Aggregated driver support patches for block gpio into one single patch
> * Added gpio block driver support for twl6040 and pch
> 
> Changes since v4:
> * Documented word width
> * Bugfix: export/unexport on register/unregister
> * Using default dev_attrs for gpio_block_class
> * Fix gpiolib: race condition on device creation
> * Added driver support for ucb14500, vt8500, xilinx
> 
> Changes since v3:
> * Added driver support for pca953x, em, pl061, max732x, pcf857x
> * Coding style improvements
> * Fixed krealloc memory leak in error case
> * sysfs: values in hex
> * Register blocks in a list
> * Narrowing lock scope
> * Use S_IWUSR and S_IRUGO instead of direct octal values
> * Use for_each_set_bit()
> * Change from unsigned to unsigned long for masks and values
> 
> Changes since v2:
> * Added sysfs support
> * Added devicetree support
> * Added support for lpc32xx, generic
> * Added functions for GPIO block registration
> * Added more error checking
> * Bit remapping bugfix
> 
> Changes since v1:
> * API change to 32/64 bit word, bit masks
> 
> Thanks to Ryan Mallon, Linus Walleij, Stijn Devriendt, Jean-Christophe
> Plagniol-Villard, Mark Brown, Greg Kroah-Hartman, Grant Likely, Stefan
> Roese and Wolfgang Grandegger for reviewing!

I re-tried v8 on my AT91-SAM9G45 board and it works fine if
CONFIG_GPIO_SYSFS is enable. Unfortunately, the access via misc device
fails if CONFIG_GPIO_SYSFS is not set. That's due to gpio_block_export()
returning -ENOSYS in gpio_block_register().

Anyway, I really like that new GPIO block interface making life for
applications fiddling with GPIOs much easier and faster. Just the poll
support is missing.

Thanks,

Wolfgang.
