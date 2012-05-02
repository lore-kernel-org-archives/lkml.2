Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2EBFMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:12:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2EBFMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:12:14 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 0/7] mmc: dw_mmc: add support for device tree based instantiation 
Date: Tue,  1 May 2012 22:07:39 -0700
Message-Id: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds device tree support for Synopsis Designware Mobile
Storage Host Controller.

The first patch adds clock lookup in the driver and this is optional. Platforms
that do not need any clock gating and control for the dw_mmc controllers will
not be affected with this change. The second patch adds a quirk to notify the
controller about the absence of the write protect line.

The third patch adds device tree support and fourth patch adds Samsung
Exynos5250 specific controlller extentions to the driver. The rest of the
patches in the series enable support for dw_mmc support on the Samsing
Exynos5250 based platforms.

This patchset has been derived from Samsung internal patches prepared by
Abhilash Kesavan <a.kesavan@samsung.com>.

Thomas Abraham (7):
  mmc: dw_mmc: lookup for optional biu and ciu clocks
  mmc: dw_mmc: add quirk to indicate missing write protect line
  mmc: dw_mmc: add device tree support
  mmc: dw_mmc: add samsung exynos5250 specific extentions
  ARM: Samsung: Add support for MSHC controller clocks
  ARM: Exynos5: Add AUXDATA support for MSHC controllers
  ARM: dts: Add nodes for dw_mmc controllers for Samsung Exynos5250 platforms

 .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |  116 +++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   50 ++++-
 arch/arm/boot/dts/exynos5250.dtsi                  |   24 ++
 arch/arm/mach-exynos/clock-exynos5.c               |   45 ++---
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    8 +
 drivers/mmc/host/dw_mmc-pltfm.c                    |   32 +++
 drivers/mmc/host/dw_mmc.c                          |  252 +++++++++++++++++++-
 drivers/mmc/host/dw_mmc.h                          |   23 ++
 include/linux/mmc/dw_mmc.h                         |   15 +-
 9 files changed, 521 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt

-- 
1.7.5.4

