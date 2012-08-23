Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412Ab2HWK57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:57:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47783 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab2HWK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:57:56 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-b3-50360cb2ad44
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        dong.aisheng@linaro.org, swarren@wwwdotorg.org, patches@linaro.org
Subject: [PATCH v3 0/4] pinctrl: add support for samsung pinctrl driver
Date: Thu, 23 Aug 2012 16:45:25 +0530
Message-id: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jQd1NPGYBBr/bZSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLOb13NVrBFoqLt1122BsYpwl2MnBwSAiYSXf/ms0LY
	YhIX7q1nA7GFBKYzSsydkt/FyAVktzFJfDkzlRkkwSZgIPFo4Tt2EFtEwFXi+IuzjCBFzAK/
	GCVeb9nEBJIQFnCXOPbhE5jNIqAq8fDJPbAGXgFPibb52xghtilJbOg9yjSBkXsBI8MqRtHU
	guSC4qT0XCO94sTc4tK8dL3k/NxNjGBvPpPewbiqweIQowAHoxIPb8A90wAh1sSy4srcQ4wS
	HMxKIrxenGYBQrwpiZVVqUX58UWlOanFhxilOViUxHn5+wwDhATSE0tSs1NTC1KLYLJMHJxS
	DYx6whaTUu367gvNPrHkbeG+Kuf5jabdBTcCNYvq3tV/M/i50PLQrM4L/y6oBAuf7tSZp9z2
	dsW6hn9bU1uZW1h/GdyTd+x+vvarS72wt7H9tnC26W0zvt7g3N5TqhOm1fDWea1739QEIY8/
	HRFv7m6dNPPde4aep3vyn9t+D1fM/BvXvfr19CQlluKMREMt5qLiRADbC2f04gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
- Fixes as suggested by Linus Walleij <linus.walleij@linaro.org>

Changes since v1:
- Added support for external gpio and wakeup interrupts for Exynos4.

This patch series adds a common pinctrl driver for all Samsung platforms and
enables the pinctrl driver support for Exynos4210 based device tree enabled
platforms. The scope of this driver is limited to only device tree enabled
platforms.

The intention of this driver is to replace the existing gpiolib driver and
provide pinctrl subsystem interface to configure the pins/mux instead
of existing platform callbacks.

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
on Exynos4210 based platforms. It allows includes support for Exynos4210
specific external gpio and wakeup interrupts which are provides to the Samsung
pinctrl driver as extensions.

The third patch modifies the existing gpiolib driver to skip the gpio pin
registrations if pinctrl driver support is found to be enabled. The fourth
patch skips the external wakeup interrupt configuration process in the
Exynos4 platform code if the external wakeup interrupt support is provided
by the pin-control driver.

Thomas Abraham (4):
  pinctrl: add samsung pinctrl and gpiolib driver
  pinctrl: add exynos4210 specific extensions for samsung pinctrl driver
  gpio: exynos4: skip gpiolib registration if pinctrl driver is used
  ARM: EXYNOS: skip wakeup interrupt setup if pinctrl driver is used

 .../bindings/pinctrl/samsung-pinctrl.txt           |  196 +++++
 arch/arm/mach-exynos/common.c                      |   26 +
 drivers/gpio/gpio-samsung.c                        |   21 +
 drivers/pinctrl/Kconfig                            |    9 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-exynos.c                   |  560 ++++++++++++
 drivers/pinctrl/pinctrl-exynos.h                   |  217 +++++
 drivers/pinctrl/pinctrl-samsung.c                  |  888 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h                  |  239 ++++++
 9 files changed, 2158 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-exynos.c
 create mode 100644 drivers/pinctrl/pinctrl-exynos.h
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h

