Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1JXWFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:05:24 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45707
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756072Ab1JXWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:05:24 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: vmbus: Support building the vmbus driver as part of the kernel
Date: Mon, 24 Oct 2011 11:28:12 -0700
Message-Id: <1319480892-26480-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the way we initialize the vmbus driver so that all the hyper-v drivers
can be linked with the kernel and still ensure that the vmbus driver
is fully initialized before the drivers that depend upon the vmbus 
driver attempt to initialize.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/vmbus_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 0c048dd..7d3bccb3 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -783,4 +783,4 @@ cleanup:
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 
-module_init(hv_acpi_init);
+subsys_initcall(hv_acpi_init);
-- 
1.7.4.1

