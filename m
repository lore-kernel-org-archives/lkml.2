Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1FUB7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:59:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab1FUB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:58:53 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-d2-4dfffad971a8
Date: Tue, 21 Jun 2011 10:58:47 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 5/5] Samsung SoC: header file revised to prevent declaring
 duplicated.
In-reply-to: <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1308621527-2457-6-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
 <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 21 Jun 2011 01:58:12.0287 (UTC)
 FILETIME=[AD2D1CF0:01CC2FB6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been no #ifndef - #define - #endif protection for this header
file.

To compile EXYNOS4 with adc support without compiler errors, this patch is essential.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
--
v2: No changes from v1. Resubmitted as a series of patches
---
 arch/arm/plat-samsung/include/plat/devs.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 4af108f..3c87779 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -12,6 +12,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
+#ifndef __PLAT_DEVS_H
+#define __PLAT_DEVS_H __FILE__
+
 #include <linux/platform_device.h>
 
 struct s3c24xx_uart_resources {
@@ -159,3 +162,5 @@ extern struct platform_device s3c_device_ac97;
  */
 extern void *s3c_set_platdata(void *pd, size_t pdsize,
 			      struct platform_device *pdev);
+
+#endif /* __PLAT_DEVS_H */
-- 
1.7.4.1

