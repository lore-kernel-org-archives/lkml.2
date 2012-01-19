Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2ASKMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:12:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13155 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab2ASKMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:12:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Jan 2012 02:12:42 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: swarren@nvidia.com, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 2/3] rtc: twl: Simplify RTC interrupt clearing
Date: Thu, 19 Jan 2012 15:42:28 +0530
Message-Id: <1326967949-8248-3-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
References: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

For clearing RTC interrupt, programming ALARM bit only is
sufficient, as all other bits are any way not affected by
writing 0 to them.

Hence removed unwanted OR operation.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/rtc-twl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 61ae1b7..1c85443 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -376,7 +376,7 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	else
 		events |= RTC_IRQF | RTC_UF;
 
-	res = twl_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
+	res = twl_rtc_write_u8(BIT_RTC_STATUS_REG_ALARM_M,
 				   REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
-- 
1.7.1.1

