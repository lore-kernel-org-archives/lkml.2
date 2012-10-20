Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2JTKXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:23:32 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:55828 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753910Ab2JTKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:22:20 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 0/5 v6] gpio: Add block GPIO
Date: Sat, 20 Oct 2012 12:21:43 +0200
Message-Id: <1350728508-22508-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds:

* Block GPIO API to gpiolib
* Sysfs support for GPIO API, to provide userland access
* Devicetree support to instantiate GPIO blocks via DT
* Example implementations in several gpio drivers since they need
  special accessor functions for block wise GPIO access
* Fix for race condition in gpiolib on device creation

Signed-off-by: Roland Stigge <stigge@antcom.de>
--

Changes since v5:
* Documented sysfs: elaborated on "exported" and "values" attributes
* Documented sysfs: gpiochip is a separate class now
* Aggregated driver support patches for block gpio into one single patch
* Added gpio block driver support for twl6040 and pch

Changes since v4:
* Documented word width
* Bugfix: export/unexport on register/unregister
* Using default dev_attrs for gpio_block_class
* Fix gpiolib: race condition on device creation
* Added driver support for ucb14500, vt8500, xilinx

Changes since v3:
* Added driver support for pca953x, em, pl061, max732x, pcf857x
* Coding style improvements
* Fixed krealloc memory leak in error case
* sysfs: values in hex
* Register blocks in a list
* Narrowing lock scope
* Use S_IWUSR and S_IRUGO instead of direct octal values
* Use for_each_set_bit()
* Change from unsigned to unsigned long for masks and values

Changes since v2:
* Added sysfs support
* Added devicetree support
* Added support for lpc32xx, generic
* Added functions for GPIO block registration
* Added more error checking
* Bit remapping bugfix

Changes since v1:
* API change to 32/64 bit word, bit masks

Thanks to Ryan Mallon, Linus Walleij, Stijn Devriendt, Jean-Christophe
Plagniol-Villard, Mark Brown and Greg Kroah-Hartman for reviewing!

Roland Stigge (5):
 gpio: Add a block GPIO API to gpiolib
 gpio: Add sysfs support to block GPIO API
 gpiolib: Fix default attributes for class
 gpio: Add device tree support to block GPIO API
 gpio: Add block gpio to several gpio drivers
 
 Documentation/ABI/testing/sysfs-gpio                  |   29 +
 Documentation/devicetree/bindings/gpio/gpio-block.txt |   36 +
 Documentation/gpio.txt                                |   47 +
 drivers/gpio/Makefile                                 |    1 
 drivers/gpio/gpio-em.c                                |   23 
 drivers/gpio/gpio-generic.c                           |   56 +
 drivers/gpio/gpio-lpc32xx.c                           |   82 ++
 drivers/gpio/gpio-max730x.c                           |   61 ++
 drivers/gpio/gpio-max732x.c                           |   59 ++
 drivers/gpio/gpio-pca953x.c                           |   64 ++
 drivers/gpio/gpio-pcf857x.c                           |   24 
 drivers/gpio/gpio-pch.c                               |   27 
 drivers/gpio/gpio-pl061.c                             |   17 
 drivers/gpio/gpio-twl6040.c                           |   32 +
 drivers/gpio/gpio-ucb1400.c                           |   23 
 drivers/gpio/gpio-vt8500.c                            |   24 
 drivers/gpio/gpio-xilinx.c                            |   44 +
 drivers/gpio/gpioblock-of.c                           |   84 ++
 drivers/gpio/gpiolib.c                                |  510 ++++++++++++++++--
 include/asm-generic/gpio.h                            |   26 
 include/linux/gpio.h                                  |   87 +++
 21 files changed, 1311 insertions(+), 45 deletions(-)
