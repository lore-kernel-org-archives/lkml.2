Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0DAMep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:34:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23284 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab0DAMej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:34:39 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: johnpol@2ka.mipt.ru, Amit Kucheria <amit.kucheria@canonical.com>
Subject: [PATCH] w1: Fix omap 1-wire driver compilation
Date: Thu,  1 Apr 2010 15:34:32 +0300
Message-Id: <9fe43ec95cb8c80ee5df94391697b81f620425bd.1270125044.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@canonical.com>

Fixes the following error:

drivers/w1/masters/omap_hdq.c: In function 'hdq_wait_for_flag':
drivers/w1/masters/omap_hdq.c:137: error: implicit declaration of function
'schedule_timeout_uninterruptible'
drivers/w1/masters/omap_hdq.c: In function 'hdq_write_byte':
drivers/w1/masters/omap_hdq.c:177: error: 'TASK_UNINTERRUPTIBLE' undeclared
(first use in this function)
drivers/w1/masters/omap_hdq.c:177: error: (Each undeclared identifier is
reported only once
drivers/w1/masters/omap_hdq.c:177: error: for each function it appears in.)
drivers/w1/masters/omap_hdq.c:177: error: implicit declaration of function
'schedule_timeout'
drivers/w1/masters/omap_hdq.c: In function 'hdq_isr':
drivers/w1/masters/omap_hdq.c:221: error: 'TASK_NORMAL' undeclared (first use
in this function)
drivers/w1/masters/omap_hdq.c: In function 'omap_hdq_break':
drivers/w1/masters/omap_hdq.c:316: error: 'TASK_UNINTERRUPTIBLE' undeclared
(first use in this function)

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/w1/masters/omap_hdq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 22977d3..77a3f00 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 
 #include <asm/irq.h>
 #include <mach/hardware.h>
-- 
1.6.3.3

