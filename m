Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2HIL7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:59:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48922 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932261Ab2HIL7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:59:49 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] timekeeping: Fix build when generic clockevents are enabled
Date: Thu,  9 Aug 2012 12:59:40 +0100
Message-Id: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a2c204 (timekeeping: Add suspend and resume of clock event devices)
added suspend and resume operations for clockevents but did not provide
stubs for these functions, breaking the build when clockevents are not
being built. Add the stubs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/clockchips.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index ca060db..4f9c280 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -170,6 +170,8 @@ extern void clockevents_notify(unsigned long reason, void *arg);
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
 
 #define clockevents_notify(reason, arg) do { } while (0)
+#define clockevents_suspend() do { } while (0)
+#define clockevents_resume() do { } while (0)
 
 #endif
 
-- 
1.7.10.4

