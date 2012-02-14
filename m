Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab2BNQN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:13:56 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:54798 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610Ab2BNQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:13:55 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH 1/2 RFC] rtc: Add ioctl to get/clear battery low voltage status
Date: Tue, 14 Feb 2012 17:13:44 +0100
Message-Id: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no generic way to get the RTC battery status within
an application. So add an ioctl to read the status bit.
The idea is that the bit is set once a low voltage is detected. It stays
there until it is reset using the RTC_VL_CLR ioctl.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 include/linux/rtc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 93f4d03..1a6ec5f 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -91,6 +91,9 @@ struct rtc_pll_info {
 #define RTC_PLL_GET	_IOR('p', 0x11, struct rtc_pll_info)  /* Get PLL correction */
 #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /* Set PLL correction */
 
+#define RTC_VL_READ	_IOR('p', 0x13, int)	/* Voltage low detector */
+#define RTC_VL_CLR	_IO('p', 0x14)		/* Clear voltage low information */
+
 /* interrupt flags */
 #define RTC_IRQF 0x80	/* Any of the following is active */
 #define RTC_PF 0x40	/* Periodic interrupt */
-- 
1.7.3.4

