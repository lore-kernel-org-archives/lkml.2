Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1FUB6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:58:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13458 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1FUB6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:58:50 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-bf-4dfffad8375e
Date: Tue, 21 Jun 2011 10:58:42 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 0/5] Update Samsung-SoC ADC (regulator / recent CPU support)
In-reply-to: <20110620101737.GA31864@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 21 Jun 2011 01:58:11.0803 (UTC)
 FILETIME=[ACE342B0:01CC2FB6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1/5: Add regulator support in ADC driver.
	If CONFIG_REGULATOR is enabled, "vdd" regulator for the ADC driver
	(e.g., "s5p-adc") should exist for the adc driver.

Patch 2/5: Channel selection method for S5PC110 and Exynos4
	Recent Samsung SoCs have different register addresses for
	channel selection. Use "s5p-adc" to support such chips.

Patch 3/5: Support ADC at Exynos4
	Define register addresses and device name for Exynos4

Patch 4/5: Support ADC at S5PC110/S5PV210
	Correct ADC device name for S5PC110/S5PV210

Patch 5/5: Header file correction (plat/devs.h)
	The long-overdue bugfix for compiler errors. ADC for Exynos4 fails to
	be compiled without this patch.

MyungJoo Ham (5):
  Samsung SoC ADC: use regulator (VDD for ADC).
  Samsung SoC ADC: Channel selection for S5PV210, S5PC110, and Exynos4
  ARM: Exynos4: Support ADC
  ARM: S5PC110/S5PV210: Support ADC
  Samsung SoC: header file revised to prevent declaring duplicated.

 arch/arm/mach-exynos4/Kconfig                 |    1 +
 arch/arm/mach-exynos4/cpu.c                   |    4 ++
 arch/arm/mach-exynos4/include/mach/irqs.h     |    8 ++++
 arch/arm/mach-exynos4/include/mach/map.h      |    5 ++
 arch/arm/mach-s5pv210/cpu.c                   |    2 +-
 arch/arm/plat-samsung/adc.c                   |   55 +++++++++++++++++++-----
 arch/arm/plat-samsung/include/plat/devs.h     |    5 ++
 arch/arm/plat-samsung/include/plat/regs-adc.h |    1 +
 8 files changed, 68 insertions(+), 13 deletions(-)

-- 
1.7.4.1

