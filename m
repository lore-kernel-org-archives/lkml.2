Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1KMTpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 14:45:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KMTpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 14:45:17 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/2] staging: et131x: Fix build error when CONFIG_PM_SLEEP not enabled
Date: Sun, 13 Nov 2011 19:43:38 +0000
Message-Id: <1321213419-5853-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap reports that the ex131x driver doesn't build when CONFIG_PM_SLEEP is not enabled.
This bug was introduced when moving code around to remove some forward declarations earlier, the #endif part of #ifdef CONFIG_PM_SLEEP was not moved at the same time. Now fixed by moving it to its proper place.

This patch is for staging-next, a similar patch has been posted for linux-next.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 5708f59..819ef10 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4477,6 +4477,12 @@ static int et131x_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
+#define ET131X_PM_OPS (&et131x_pm_ops)
+#else
+#define ET131X_PM_OPS NULL
+#endif
+
 /* ISR functions */
 
 /**
@@ -5452,12 +5458,6 @@ err_disable:
 	goto out;
 }
 
-static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
-#define ET131X_PM_OPS (&et131x_pm_ops)
-#else
-#define ET131X_PM_OPS NULL
-#endif
-
 static DEFINE_PCI_DEVICE_TABLE(et131x_pci_table) = {
 	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
 	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},
-- 
1.7.7.1

