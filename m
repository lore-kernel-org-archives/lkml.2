Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KZRGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:12 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0KZRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=bGtll4coHEmODCE6TA4u6FXRz70pI5QCyk/Qh/B3291kxDdvy9CFSHwU1oaf2SRxra
         APlZ8MBPwFxfjvCWrgcarrftJDyBRGwfPupe1Jqf2Y2nffsPd+VPq5xpjsewXudBopkf
         8RqCePCCAjz4i2fqOTPSj74NLx/Cdqe59RCco=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: plat-omap: counter_32k: use IS_ERR() instead of NULL check
Date: Fri, 26 Nov 2010 20:06:02 +0300
Message-Id: <1290791163-21190-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns ERR_PTR() on error, not NULL.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/arm/plat-omap/counter_32k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index 155fe43..c1e0d00 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -164,7 +164,7 @@ static int __init omap_init_clocksource_32k(void)
 			return -ENODEV;
 
 		sync_32k_ick = clk_get(NULL, "omap_32ksync_ick");
-		if (sync_32k_ick)
+		if (!IS_ERR(sync_32k_ick))
 			clk_enable(sync_32k_ick);
 
 		clocksource_32k.mult = clocksource_hz2mult(32768,
-- 
1.7.0.4

