Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab1FWRZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab1FWRZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:25:36 -0400
Date: Thu, 23 Jun 2011 13:25:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172535.27783.18666.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 33/35] Kernel panic changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel panic changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 kernel/panic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6923167..7b35089b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -22,7 +22,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -370,7 +370,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	board = sysfw_lookup(SYSFW_PRODUCT_NAME);
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-- 
1.7.5.4

