Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555Ab2DLSpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:45:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43812 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab2DLSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:19 -0400
Date: Thu, 12 Apr 2012 20:45:19 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [RFC/PATCH 00/13] ARM: Exynos4: Add DTS for Samsung's Nuri board
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is just an RFC for those interested DT-support progress on samsung
  boards. ]

This patchset provides up to date patches for drivers used on Samsung's
Nuri board.  Additionally, expermiental (and incomplete) .dts is also
provided.

Included .dts provides description for many, but not all devices found
in mach-nuri.c.  Currently mmc, fimc and mfc aren't supported.


This patch series is based on mainline v3.4-rc2 with following patches
applied: 

 1. [PATCH v5 0/2] ARM: Exynos: Add irq_domain and device tree support for combiner

    http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/10296

 2. [PATCH v4 0/4] ARM: Exynos4: Add irq domain and device tree support for wakeup interrupts

    http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/10302 

 3. [PATCH v4 0/2] regulator: add irq domain and device tree support for MAX8997

    http://permalink.gmane.org/gmane.linux.drivers.devicetree/13995

 4. [PATCH v3 0/3] i2c-s3c2410: Updates for exynos4210 and DT-based systems

    http://permalink.gmane.org/gmane.linux.drivers.i2c/10380


  [ In this patch series I have also included tiny fix for i2c-gpio,
    rebased for v3.4-rc2, originally found here: 

    http://permalink.gmane.org/gmane.linux.drivers.i2c/10414 ]


Karol Lewandowski (13):
  regulator: Fix DT node name checking in max8997-pmic
  ARM: Add document to list devices with trivial DT description
  s5p-g2d: Make it possible to instantiate driver from DT
  i2c-pxa: Drop leftover comment
  i2c: Dynamically assign adapter id if it wasn't explictly specified
  s5p-tv: Add initial DT-support for SiI9234
  s5p-tv: Add initial DT-support for TV mixer
  s5p-tv: Add initial DT-support for HDMIPHY
  s5p-tv: Move HDMIPHY and MHL subdev probing to dedicated function
  s5p-tv: Add DT-support for HDMI driver
  ARM: Exynos4: dts: Specify address and size cells for i2c controllers
  ARM: Exynos4: Add few more i2c OF compat definitions
  ARM: dts: Add initial dts for Samsung's NURI board based on
    Exynos4210

 .../devicetree/bindings/arm/exynos/tvmixer.txt     |   26 +
 .../devicetree/bindings/arm/trivial-devices.txt    |   11 +
 .../devicetree/bindings/i2c/sil-mhl9234.txt        |   14 +
 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 arch/arm/boot/dts/exynos4210-nuri.dts              |  527 ++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   16 +
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   10 +
 drivers/i2c/busses/i2c-gpio.c                      |    7 +-
 drivers/i2c/busses/i2c-pca-platform.c              |    2 +-
 drivers/i2c/busses/i2c-pxa.c                       |    5 -
 drivers/i2c/busses/i2c-versatile.c                 |    9 +-
 drivers/media/video/s5p-g2d/g2d.c                  |   10 +
 drivers/media/video/s5p-tv/hdmi_drv.c              |  158 +++++--
 drivers/media/video/s5p-tv/hdmiphy_drv.c           |   10 +
 drivers/media/video/s5p-tv/mixer_drv.c             |    9 +
 drivers/media/video/s5p-tv/sii9234_drv.c           |   21 +-
 drivers/regulator/max8997.c                        |    7 +
 17 files changed, 781 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/exynos/tvmixer.txt
 create mode 100644 Documentation/devicetree/bindings/arm/trivial-devices.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/sil-mhl9234.txt
 create mode 100644 arch/arm/boot/dts/exynos4210-nuri.dts

-- 
1.7.9.1

