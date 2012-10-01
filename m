Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2JAMJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:09:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38434 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2JAMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:09:35 -0400
From: chander.kashyap@linaro.org
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, mturquette@ti.com,
        linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH 0/2] ARM: Exynos4: Migrate to common clock framework.
Date: Mon,  1 Oct 2012 17:39:19 +0530
Message-Id: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.abraham@linaro.org>

This patch series migrates Exynos4 clock support to common clock framework.
The first patch in this series removes the existing Exynos4 clock support
that uses the Samsung specific clock framework. The second patch in this
series add Exynos4 clock support using common clock framework.

Thomas Abraham (2):
  ARM: Exynos4: Remove Samsung clock type support
  ARM: Exynos4: Register clocks via common clock framework

 arch/arm/mach-exynos/Kconfig               |    1 +
 arch/arm/mach-exynos/Makefile              |    3 -
 arch/arm/mach-exynos/clock-exynos4.c       | 1572 ----------------------------
 arch/arm/mach-exynos/clock-exynos4.h       |   35 -
 arch/arm/mach-exynos/clock-exynos4210.c    |  188 ----
 arch/arm/mach-exynos/clock-exynos4212.c    |  192 ----
 arch/arm/mach-exynos/common.c              |   18 +-
 arch/arm/mach-exynos/common.h              |    3 +
 arch/arm/mach-exynos/mach-armlex4210.c     |    1 -
 arch/arm/mach-exynos/mach-exynos4-dt.c     |    1 -
 arch/arm/mach-exynos/mach-nuri.c           |    1 -
 arch/arm/mach-exynos/mach-origen.c         |    1 -
 arch/arm/mach-exynos/mach-smdk4x12.c       |    1 -
 arch/arm/mach-exynos/mach-smdkv310.c       |    1 -
 arch/arm/mach-exynos/mach-universal_c210.c |    1 -
 arch/arm/mach-exynos/mct.c                 |   11 +-
 arch/arm/plat-samsung/Kconfig              |    4 +-
 drivers/clk/Makefile                       |    1 +
 drivers/clk/clk.c                          |   12 +-
 drivers/clk/samsung/Makefile               |    6 +
 drivers/clk/samsung/clk-exynos4.c          |  585 +++++++++++
 drivers/clk/samsung/clk.c                  |  231 ++++
 drivers/clk/samsung/clk.h                  |  190 ++++
 23 files changed, 1043 insertions(+), 2016 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4.c
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4.h
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4210.c
 delete mode 100644 arch/arm/mach-exynos/clock-exynos4212.c
 create mode 100644 drivers/clk/samsung/Makefile
 create mode 100644 drivers/clk/samsung/clk-exynos4.c
 create mode 100644 drivers/clk/samsung/clk.c
 create mode 100644 drivers/clk/samsung/clk.h

