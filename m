Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0DSOLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:11:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0DSOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:11:23 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
       johnpol@2ka.mipt.ru
Subject: [PATCH] Drivers: w1: omap_hdq: Fix missing include sched.h
Date: Mon, 19 Apr 2010 16:10:36 +0000
Message-Id: <1271693436-14950-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.6.4.4
X-Provags-ID: V01U2FsdGVkX19qG0AsPITfGrwBOJbTlWRbDRxqgC0jL1wKlAy
 mX8H5U3PggWvui0g165RGNnlv+wkGj8yooJe+vVVU8/hnfs9q8
 Yr9uPhbiHvqiI0HvUR7cA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit f6a570333e554b48ad589e7137c77c57809eee81 #include <sched.h> was
removed from module.h and not added in omap_hdq.c .

The definition for TASK_UNINTERRUPTIBLE and
schedule_timeout_uninterruptible are missing.
This patch fixes the missing definition.

Signed-off-by: Thomas Weber <weber@corscience.de>
---

 drivers/w1/masters/omap_hdq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index ef36fca..3a7e9ff 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 
 #include <asm/irq.h>
 #include <mach/hardware.h>
-- 
1.6.4.4

