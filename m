Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2HOTkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:40:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26005 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2HOTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:40:31 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-fa-502bfb2d8720
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH v2 0/4] pinctrl: add support for samsung pinctrl driver
Date: Thu, 16 Aug 2012 01:27:32 +0530
Message-id: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jAV2939oBBlObWC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIab11lK7gtXtH+/DN7A+MZoS5GTg4JAROJnV9eskDY
	YhIX7q1n62Lk4hASWMQo0db4jwnCaWOS+PXtFRtIFZuAgcSjhe/YQWwRAQWJzb3PWEGKmAVO
	MErc7jsJlhAWcJf48GAKM4jNIqAqMXnnCrAVvAKeEr2rzzNCrFOS2NB7lGkCI/cCRoZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMH+fCa1g3Flg8UhRgEORiUeXoaDWgFCrIllxZW5hxgl
	OJiVRHh/nNIOEOJNSaysSi3Kjy8qzUktPsQozcGiJM5r7P3VX0ggPbEkNTs1tSC1CCbLxMEp
	1cB4TGD29GYJydOCorn2T1PWn5VJ8ZX0EHihpCs24fLtSwc0zy5bd/XhSdvw32tyblfEPeNt
	dNt6cfcXTdunH8RkHTR/8d+fc4RLsV57orIkJ+vp7/ZOF7Y7vHv30d6h6cnaGS95Jtx9uSSJ
	wbPg3hXR/as2dQs8LN1R9ki89Vfj9Kz/5sumHeMTUWIpzkg01GIuKk4EAMngOAXjAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

.../bindings/pinctrl/samsung-pinctrl.txt           |  176 ++++
 arch/arm/mach-exynos/common.c                      |   26 +
 drivers/gpio/gpio-samsung.c                        |   21 +
 drivers/pinctrl/Kconfig                            |   11 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-exynos.c                   |  555 +++++++++++++
 drivers/pinctrl/pinctrl-exynos.h                   |  213 +++++
 drivers/pinctrl/pinctrl-samsung.c                  |  873 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h                  |  215 +++++
 9 files changed, 2092 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-exynos.c
 create mode 100644 drivers/pinctrl/pinctrl-exynos.h
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h

