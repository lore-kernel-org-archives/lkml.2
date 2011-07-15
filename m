Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1GORte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:49:34 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37180
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754002Ab1GOR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 026/117] Staging: hv: util: Get rid of the PCI signature in hv_util.c
Date: Fri, 15 Jul 2011 10:46:14 -0700
Message-Id: <1310752065-27895-26-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
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
index 6fabc99..26693dd 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/reboot.h>
-#include <linux/pci.h>
 
 #include "hyperv.h"
 #include "hv_kvp.h"
@@ -271,13 +270,6 @@ static  struct hv_driver util_drv = {
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

