Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1DDNcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:32:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47322 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754028Ab1DDNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:32:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove compatibility interface for WM831x specific IRQ API
Date: Mon,  4 Apr 2011 11:04:12 +0900
Message-Id: <1301882652-29264-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user was removed in the merge window.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm831x/core.h |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 903280d..0d515ee 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -301,30 +301,4 @@ int wm831x_device_suspend(struct wm831x *wm831x);
 int wm831x_irq_init(struct wm831x *wm831x, int irq);
 void wm831x_irq_exit(struct wm831x *wm831x);
 
-static inline int __must_check wm831x_request_irq(struct wm831x *wm831x,
-						  unsigned int irq,
-						  irq_handler_t handler,
-						  unsigned long flags,
-						  const char *name,
-						  void *dev)
-{
-	return request_threaded_irq(irq, NULL, handler, flags, name, dev);
-}
-
-static inline void wm831x_free_irq(struct wm831x *wm831x,
-				   unsigned int irq, void *dev)
-{
-	free_irq(irq, dev);
-}
-
-static inline void wm831x_disable_irq(struct wm831x *wm831x, int irq)
-{
-	disable_irq(irq);
-}
-
-static inline void wm831x_enable_irq(struct wm831x *wm831x, int irq)
-{
-	enable_irq(irq);
-}
-
 #endif
-- 
1.7.4.1

