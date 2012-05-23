Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2EWXwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:52:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44118 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2EWXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:52:05 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Subject: [PATCH 0/3] pinctrl: add support for samsung pinctrl driver
Date: Thu, 24 May 2012 05:17:34 +0530
Message-Id: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a common pinctrl driver for all Samsung platforms and
enables the pinctrl driver support for Exynos4210 based device tree enabled
platforms. The scope of this driver is limited to only device tree enabled
platforms.

The intention of this driver is to replace the existing gpiolib driver and
provide pinctrl subsystem interface to configure the pins/mux instead
of existing platform callbacks. At this point, the pinmux and pinconfig
functionality is fully supported. Additional work is required to add gpio
interrupts and wakeup interrupts support but that should not stop device
drivers from switching over to use the pinctrl subsystem to configure
the io-pads.

Note that, the Samsung pinctrl driver is usable only on device tree enabled
Samsung platforms. Legacy platforms would still continue to use the older
gpiolib driver and hence updates to device drivers to use the pinctrl api
should ensure that support for legacy platforms is maintained.

The first patch adds a new pinctrl driver for Samsung. It provides interfaces
to the pinctrl and gpiolib subsystems. This driver provides a common framework
for all Samsung SoC's to enable the pinctrl and gpiolib support. The driver
accepts the information about pins, groups and functions from the device tree
and the information about gpio banks is supplied using driver data.

The second patch adds the driver data required to operate the pinctrl driver
on Exynos4210 based platforms. The third patch modifies the existing gpiolib
driver to skip the gpio pin registrations if pinctrl driver support is found
to be enabled.

Thomas Abraham (3):
  pinctrl: add samsung pinctrl and gpiolib driver
  pinctrl: add exynos4210 specific driver data for samsung pinctrl driver
  gpio: exynos4: skip gpiolib registration if pinctrl driver is used

 .../bindings/pinctrl/samsung-pinctrl.txt           |  111 +++
 drivers/gpio/gpio-samsung.c                        |   21 +
 drivers/pinctrl/Kconfig                            |   11 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-exynos4.c                  |  211 +++++
 drivers/pinctrl/pinctrl-samsung.c                  |  881 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h                  |  170 ++++
 7 files changed, 1407 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-exynos4.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h


