Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab0HJS73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:59:29 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:35465 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932606Ab0HJS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:59:09 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] VMware balloon: export module version as module parameter
Date: Tue, 10 Aug 2010 11:58:45 -0700
Message-Id: <1281466725-22549-2-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1281466725-22549-1-git-send-email-dtor@vmware.com>
References: <1281466725-22549-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow external tools detect presence of the driver in the kernel
when the driver is built in (as opposed to be compiled as a module)
export driver version as a read-only module parameter.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmware_balloon.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
index 2a1e804..f9b2221 100644
--- a/drivers/misc/vmware_balloon.c
+++ b/drivers/misc/vmware_balloon.c
@@ -43,9 +43,11 @@
 #include <linux/seq_file.h>
 #include <asm/hypervisor.h>
 
+#define VMW_BALLOON_VERSION	"1.2.1.2-k"
+
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.1-k");
+MODULE_VERSION(VMW_BALLOON_VERSION);
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -842,3 +844,13 @@ static void __exit vmballoon_exit(void)
 	vmballoon_pop(&balloon);
 }
 module_exit(vmballoon_exit);
+
+/*
+ * Make the driver version exported as module parameter so that the
+ * driver is still visible if it is compiled into kernel
+ */
+static int param_get_vmballoon_version(char *buffer, struct kernel_param *kp)
+{
+	return sprintf(buffer, "%s", VMW_BALLOON_VERSION);
+}
+module_param_call(version, NULL, param_get_vmballoon_version, NULL, S_IRUGO);
-- 
1.7.0

