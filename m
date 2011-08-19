Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1HSWLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:11:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44355 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755515Ab1HSWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:11:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki\"" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] PM: Fix build due to missing notifier header
Date: Fri, 19 Aug 2011 17:43:05 +0900
Message-Id: <1313743385-8394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_clock.h uses a struct notifier_block without including notifier.h which
appears to have caused it to fall victim to some of the current header
reorganisations in -next. Fix the resulting build failures.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/pm_clock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_clock.h b/include/linux/pm_clock.h
index f888013..8348866 100644
--- a/include/linux/pm_clock.h
+++ b/include/linux/pm_clock.h
@@ -10,6 +10,7 @@
 #define _LINUX_PM_CLOCK_H
 
 #include <linux/device.h>
+#include <linux/notifier.h>
 
 struct pm_clk_notifier_block {
 	struct notifier_block nb;
-- 
1.7.5.4

