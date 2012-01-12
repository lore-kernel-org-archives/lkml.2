Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2ALODt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:03:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39432 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab2ALODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:03:48 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-serial@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH RFC 1/2] ARM : OMAP : serial : Make context_loss_cnt signed
Date: Thu, 12 Jan 2012 19:33:38 +0530
Message-ID: <1326377019-23688-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_context_loss_count returns an int however it is stored in
unsigned integer context_loss_cnt . This patch tries to make
context_loss_cnt int. So that in case of errors(which may be negative)
the value is not interpreted wrongly.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
applies on Tony's uart branch

 arch/arm/plat-omap/include/plat/omap-serial.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 9ff4444..b7fb6dc 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -128,7 +128,7 @@ struct uart_omap_port {
 	unsigned char		msr_saved_flags;
 	char			name[20];
 	unsigned long		port_activity;
-	u32			context_loss_cnt;
+	int			context_loss_cnt;
 	u32			errata;
 	u8			wakeups_enabled;
 
-- 
1.7.1

