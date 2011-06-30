Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1F3Htq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:49:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46463 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1F3Hth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:49:37 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-32-4e0c2a8f01d8
Date: Thu, 30 Jun 2011 16:49:29 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 0/6] Update Samsung-SoC ADC to support recent CPUs
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Seungwhan Youn <sw.youn@samsung.com>, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com
Message-id: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 30 Jun 2011 07:49:50.0110 (UTC)
 FILETIME=[4A2D2BE0:01CC36FA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1/6: Add regulator support in ADC driver.
	If CONFIG_REGULATOR is enabled, "vdd" regulator for the ADC driver
	(e.g., "s5p-adc") should exist for the adc driver.

Patch 2/6: Channel selection method for S5PC110 and Exynos4
	Recent Samsung SoCs have different register addresses for
	channel selection. Use "s5p-adc" to support such chips.

Patch 3/6: Bugfix for suspend/resume of ADC driver.

Patch 4/6: Support ADC at Exynos4
	Define register addresses and device name for Exynos4

Patch 5/6: Support ADC at S5PC110/S5PV210
	Correct ADC device name for S5PC110/S5PV210

Patch 6/6: Header file correction (plat/devs.h)
	The long-overdue bugfix for compiler errors. ADC for Exynos4 fails to
	be compiled without this patch.


MyungJoo Ham (6):
  Samsung SoC ADC: use regulator (VDD for ADC).
  Samsung SoC ADC: Channel selection for S5PV210, S5PC110, and Exynos4
  Samsung SoC ADC: Revise PM for 12-bit ADC operations
  ARM: EXYNOS4: Support ADC
  ARM: S5PC110/S5PV210: Support ADC
  Samsung SoC: header file revised to prevent declaring duplicated.

 arch/arm/mach-exynos4/Kconfig                 |    1 +
 arch/arm/mach-exynos4/cpu.c                   |    4 +
 arch/arm/mach-exynos4/include/mach/irqs.h     |    3 +
 arch/arm/mach-exynos4/include/mach/map.h      |    5 ++
 arch/arm/mach-s5pv210/cpu.c                   |    2 +-
 arch/arm/plat-samsung/adc.c                   |   84 +++++++++++++++++++------
 arch/arm/plat-samsung/include/plat/devs.h     |    5 ++
 arch/arm/plat-samsung/include/plat/regs-adc.h |    1 +
 8 files changed, 84 insertions(+), 21 deletions(-)

-- 
1.7.4.1

