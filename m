Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1HYQau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:30:50 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42925
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753579Ab1HYQ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 57/59] Staging: hv: mouse: Get rid of  the unused  PCI signature
Date: Thu, 25 Aug 2011 09:49:23 -0700
Message-Id: <1314290965-2698-57-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of  the unused  PCI signature in the mouse driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index cbb837b..a29a050 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -22,8 +22,6 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 #include <linux/hiddev.h>
-#include <linux/pci.h>
-#include <linux/dmi.h>
 
 #include "hyperv.h"
 
@@ -956,26 +954,6 @@ static void __exit mousevsc_exit(void)
 	mousevsc_drv_exit();
 }
 
-/*
- * We don't want to automatically load this driver just yet, it's quite
- * broken.  It's safe if you want to load it yourself manually, but
- * don't inflict it on unsuspecting users, that's just mean.
- */
-#if 0
-
-/*
- * We use a PCI table to determine if we should autoload this driver  This is
- * needed by distro tools to determine if the hyperv drivers should be
- * installed and/or configured.  We don't do anything else with the table, but
- * it needs to be present.
- */
-static const struct pci_device_id microsoft_hv_pci_table[] = {
-	{ PCI_DEVICE(0x1414, 0x5353) },	/* VGA compatible controller */
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
-#endif
-
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 module_init(mousevsc_init);
-- 
1.7.4.1

