Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1HYQ26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:28:58 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42703
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752188Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 01/59] Staging: hv: vmbus: VMBUS is an ACPI enumerated device, get rid of the PCI signature
Date: Thu, 25 Aug 2011 09:48:27 -0700
Message-Id: <1314290965-2698-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290866-2644-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMBUS is an ACPI enumerated device, get rid of the PCI signature.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 67a4f33..8f1d6eb 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -28,7 +28,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
-#include <linux/pci.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
@@ -754,18 +753,6 @@ static struct acpi_driver vmbus_acpi_driver = {
 	},
 };
 
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
-
 static int __init hv_acpi_init(void)
 {
 	int ret, t;
-- 
1.7.4.1

