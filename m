Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2CZInI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:43:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37345 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2CZInE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:43:04 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-f3-4f702c17220a
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, florianSchandinat@gmx.de,
        devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, lars@metafoo.de,
        patches@linaro.org
Subject: [PATCH v3 0/2] Add lcd driver for panels with gpio controlled panel
 reset
Date: Mon, 26 Mar 2012 14:16:38 +0530
Message-id: <1332751600-11371-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
- Reworked as per comments[1] from Mark Brown.
  - removed the setting of regulator voltage.

[1] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg08743.html

Changes since v1:
- Fixed gpio leak, added MODULE_DEVICE_TABLE and dev_pm_ops.
- Changed device tree bindings.

This patchset adds support for passive panels that use a nRESET line which is
controlled by a GPIO of the host system and which do not use a serial comamnd
interface (i2c or spi) or memory-mapped-io interface. Platforms that do not
require any additional control apart from the nRESET line can use this driver
for lcd power control.

The first patch adds driver for passive raster-type lcd's with gpio controlled
panel reset. It includes support for both dt and non-dt platforms. The second
patch adds support for using this driver on Origen board.

Thomas Abraham (2):
  backlight: lcd: add driver for raster-type lcd's with gpio controlled panel reset
  ARM: Exynos: Use lcd power control driver for lcd panel

 .../devicetree/bindings/lcd/lcd-pwrctrl.txt        |   36 +++
 arch/arm/mach-exynos/mach-origen.c                 |   29 +--
 drivers/video/backlight/Kconfig                    |    7 +
 drivers/video/backlight/Makefile                   |    1 +
 drivers/video/backlight/lcd_pwrctrl.c              |  226 ++++++++++++++++++++
 include/video/lcd_pwrctrl.h                        |   24 ++
 6 files changed, 300 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
 create mode 100644 drivers/video/backlight/lcd_pwrctrl.c
 create mode 100644 include/video/lcd_pwrctrl.h

