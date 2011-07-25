Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1GYPet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:34:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41662 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1GYPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:34:47 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] dw_apb_timer: constify clocksource name
Date: Mon, 25 Jul 2011 16:34:37 +0100
Message-Id: <1311608077-4759-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource name should be const for correctness.

Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/clocksource/dw_apb_timer.c |    2 +-
 include/linux/dw_apb_timer.h       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 580f870..8c2a35f 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -348,7 +348,7 @@ static void apbt_restart_clocksource(struct clocksource *cs)
  * dw_apb_clocksource_register() as the next step.
  */
 struct dw_apb_clocksource *
-dw_apb_clocksource_init(unsigned rating, char *name, void __iomem *base,
+dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 			unsigned long freq)
 {
 	struct dw_apb_clocksource *dw_cs = kzalloc(sizeof(*dw_cs), GFP_KERNEL);
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 49638ea..07261d5 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -46,7 +46,7 @@ struct dw_apb_clock_event_device *
 dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 		       void __iomem *base, int irq, unsigned long freq);
 struct dw_apb_clocksource *
-dw_apb_clocksource_init(unsigned rating, char *name, void __iomem *base,
+dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 			unsigned long freq);
 void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
-- 
1.7.4.1

