Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1EDPc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:32:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42851 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1EDPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:32:25 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 3/3] rtc: mxc: remove UIE signaling
Date: Wed,  4 May 2011 17:31:28 +0200
Message-Id: <1304523088-17039-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
References: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTC core handles it since 6610e08 (RTC: Rework RTC code to use
timerqueue for events).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/rtc/rtc-mxc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index d814417..c996218 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -213,9 +213,6 @@ static irqreturn_t mxc_rtc_interrupt(int irq, void *dev_id)
 	if (status & RTC_ALM_BIT)
 		events |= (RTC_AF | RTC_IRQF);
 
-	if (status & RTC_1HZ_BIT)
-		events |= (RTC_UF | RTC_IRQF);
-
 	if (status & PIT_ALL_ON)
 		events |= (RTC_PF | RTC_IRQF);
 
-- 
1.7.2.5

