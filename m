Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1HYQlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:41:00 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42737
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753372Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 19/59] Staging: hv: util: Get rid of the PCI signature in hv_util.c
Date: Thu, 25 Aug 2011 09:48:45 -0700
Message-Id: <1314290965-2698-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have implemented a vmbus specific mechanism for auto-loading,
get rid of the PCI signature.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_util.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index aed9187..1b0ec0e 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/reboot.h>
-#include <linux/pci.h>
 
 #include "hyperv.h"
 #include "hv_kvp.h"
@@ -268,13 +267,6 @@ static  struct hv_driver util_drv = {
 	.remove =  util_remove,
 };
 
-static const struct pci_device_id __initconst
-hv_utils_pci_table[] __maybe_unused = {
-	{ PCI_DEVICE(0x1414, 0x5353) }, /* Hyper-V emulated VGA controller */
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, hv_utils_pci_table);
-
 static int __init init_hyperv_utils(void)
 {
 	pr_info("Registering HyperV Utility Driver\n");
-- 
1.7.4.1

