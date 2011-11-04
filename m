Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1KDR7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:59:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45088 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1KDR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:59:40 -0400
From: Mark Einon <mark.einon@gmail.com>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        gregkh@suse.de, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] linux-next: et131x: Fix build error when CONFIG_PM_SLEEP not enabled
Date: Fri,  4 Nov 2011 17:58:02 +0000
Message-Id: <1320429482-2332-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EB30C0B.8080200@xenotime.net>
References: <4EB30C0B.8080200@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap reports that the ex131x driver doesn't build when CONFIG_PM_SLEEP is not enabled.
This bug was introduced when moving code around to remove some forward declarations earlier, the #endif part of #ifdef CONFIG_PM_SLEEP was not moved at the same time. Now fixed by moving it to its proper place.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index f5f44a0..0c1c6ca 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4469,6 +4469,12 @@ static int et131x_resume(struct device *dev)
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
@@ -5470,12 +5476,6 @@ err_out:
 	return result;
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
1.7.6.4

