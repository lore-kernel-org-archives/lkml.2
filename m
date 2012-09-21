Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2IUK4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:56:01 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5792 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab2IUK4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:56:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 21 Sep 2012 03:47:09 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] mfd: tps65910: Add alarm interrupt of TPS65910 RTC to mfd device list
Date: Fri, 21 Sep 2012 16:25:36 +0530
Message-ID: <1348224936-31938-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTC alarm interrupt details to TPS65910 MFD device list, to support
RTC alarm events.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/mfd/tps65910.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d030457..3404249 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -24,6 +24,14 @@
 #include <linux/mfd/tps65910.h>
 #include <linux/of_device.h>
 
+static struct resource rtc_resources[] = {
+	{
+		.start  = TPS65910_IRQ_RTC_ALARM,
+		.end    = TPS65910_IRQ_RTC_ALARM,
+		.flags  = IORESOURCE_IRQ,
+	}
+};
+
 static struct mfd_cell tps65910s[] = {
 	{
 		.name = "tps65910-gpio",
@@ -33,6 +41,8 @@ static struct mfd_cell tps65910s[] = {
 	},
 	{
 		.name = "tps65910-rtc",
+		.num_resources = ARRAY_SIZE(rtc_resources),
+		.resources = &rtc_resources[0],
 	},
 	{
 		.name = "tps65910-power",
-- 
1.7.1.1

