Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2ALHi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:38:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23599 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ALHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:38:24 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-72-4f0e8ded7d65
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, lars@metafoo.de, patches@linaro.org
Subject: [PATCH v2 0/2] Add lcd driver for panels with gpio controlled panel
 reset
Date: Thu, 12 Jan 2012 13:13:29 +0530
Message-id: <1326354211-27064-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- Fixed gpio leak, added MODULE_DEVICE_TABLE and dev_pm_ops.
- Changed device tree bindings.

This patchset adds support for passive panels that do not use a nRESET line
which is controlled by a GPIO of the host system and which do not use a
serial comamnd interface (i2c or spi) or memory-mapped-io interface.

The first patch adds driver for passive raster-type lcd's with gpio controlled
panel reset. It includes support for both dt and non-dt platforms. The second
patch adds support for using this driver on Origen board.

Thomas Abraham (2):
  backlight: lcd: add driver for raster-type lcd's with gpio controlled panel reset
  ARM: Exynos: Use lcd power control driver for lcd panel

 .../devicetree/bindings/lcd/lcd-pwrctrl.txt        |   48 ++++
 arch/arm/mach-exynos/mach-origen.c                 |   29 +--
 drivers/video/backlight/Kconfig                    |    7 +
 drivers/video/backlight/Makefile                   |    1 +
 drivers/video/backlight/lcd_pwrctrl.c              |  232 ++++++++++++++++++++
 include/video/lcd_pwrctrl.h                        |   34 +++
 6 files changed, 328 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
 create mode 100644 drivers/video/backlight/lcd_pwrctrl.c
 create mode 100644 include/video/lcd_pwrctrl.h

