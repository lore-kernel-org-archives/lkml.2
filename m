Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0FUIEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 04:04:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16650 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0FUIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 04:04:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 21 Jun 2010 10:04:23 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] drivers: regulators: depend on MFD_MAX8998
In-reply-to: <20100618003116.GA2761@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <1277107463-28153-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100618003116.GA2761@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX8998-pmic driver requires a core driver for all io operations. Like
other regulator driver make it depend of the required MFD io driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e190164..bfd00a2 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -102,8 +102,7 @@ config REGULATOR_MAX8925
 
 config REGULATOR_MAX8998
 	tristate "Maxim 8998 voltage regulator"
-	depends on I2C
-	default n
+	depends on MFD_MAX8998
 	help
 	  This driver controls a Maxim 8998 voltage output regulator
 	  via I2C bus. The provided regulator is suitable for S3C6410
-- 
1.7.1.240.g225c

