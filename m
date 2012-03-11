Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2CKMl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:41:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54735 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2CKMlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:41:52 -0400
X-AuditID: cbfee61b-b7c62ae000000989-71-4f5c9d8ec877
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 0/5] pinctrl: add new Samsung pinctrl driver and add Exynos4
 support
Date: Sun, 11 Mar 2012 18:16:00 +0530
Message-id: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds new pinctrl driver for Samsung SoC's. The driver supports
a gpiolib interface as well since Samsung SoC's have a combined pinmux/pinctrl
and gpio controller.

The intention of this driver is to replace the existing gpiolib driver and
provide drivers pinctrl subsystem interface to configure the pins/mux instead
of existing platform callbacks. At this point, the pinmux and pinconfig
functionality fully supported and gpiolib is partially supported. Additional
work is required to add gpio interrupts and wakeup interrupts support.

Hence, this is not ready for merge yet. The first two patches can be looked at
in detail. The last three patches are mainly work-in-progress and can be
glanced over.

The first patch adds a new pinctrl driver for Samsung. It provides interfaces
to the pinctrl and gpiolib subsystems. This driver provides a common framework
for all Samsung SoC's to enable the pinctrl and gpiolib support. The driver
accepts the information about pins, groups, functions and gpio chips using
the driver data.

The second patch adds information about the pins, groups, functions and gpio
chips for the Exynos4210 SoC's. This information is supplied to the Samsung
pinctrl driver using driver data. The pinctrl driver registers this information
with the pinctrl and gpiolib subsystems. Note: The information about the
commonly used groups and functions are added, this list is not exhaustive.

The third patch add support for all three pinctrl devices on Exynos4210 SoC.
It also adds a minimal common reusable pin maps for boards which are based on
Exynos4210 as an example. The pin maps is listed only for the sdhci2 controller
for now and this list needs to be expanded.

The fourth patch enables pinctrl driver support for Exynos4210 based Origen
board as an example of using pinctrl driver.

The fifth patch updates the sdhci-s3c driver to use the pinctrl driver
interface to setup the pin mux and config settings. This is only intended
to be a an example of how to replace the platform callbacks with the
pinctrl driver call.

This patchset is based on
http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git

with all patches merged from
http://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git [for-next]

and tested working of sdhci2 controller on Origen board.

Thomas Abraham (5):
  pinctrl: add samsung pinctrl and gpiolib driver
  pinctrl: add exynos4 specific pins, groups, functions and gpio chip data
  ARM: Exynos4: Add pinctrl devices and pin maps
  ARM: Exynos: Enable pinctrl driver support for Origen board
  mmc: sdhci-s3c: setup pins using pinctrl interface

 arch/arm/mach-exynos/Kconfig                 |    1 +
 arch/arm/mach-exynos/Makefile                |    1 +
 arch/arm/mach-exynos/common.h                |    6 +
 arch/arm/mach-exynos/dev-pinctrl.c           |  115 +++++
 arch/arm/mach-exynos/mach-origen.c           |    7 +
 arch/arm/plat-samsung/include/plat/devs.h    |    3 +
 arch/arm/plat-samsung/include/plat/pinctrl.h |   35 ++
 drivers/mmc/host/sdhci-s3c.c                 |   15 +-
 drivers/pinctrl/Kconfig                      |   10 +
 drivers/pinctrl/Makefile                     |    2 +
 drivers/pinctrl/pinctrl-exynos4.c            |  522 +++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c            |  589 ++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h            |  143 +++++++
 13 files changed, 1447 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-exynos/dev-pinctrl.c
 create mode 100644 arch/arm/plat-samsung/include/plat/pinctrl.h
 create mode 100644 drivers/pinctrl/pinctrl-exynos4.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h

