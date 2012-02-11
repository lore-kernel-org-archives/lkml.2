Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2BKTpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:45:10 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:52794 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2BKToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:44:24 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 12/13] firewire-sbp-target: Add sbp_util.{c,h}
Date: Sat, 11 Feb 2012 19:44:11 +0000
Message-Id: <1328989452-20921-13-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328989452-20921-1-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
 <1328989452-20921-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common helper functions and global declarations.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/sbp_util.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_util.h |   15 +++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/sbp/sbp_util.c
 create mode 100644 drivers/target/sbp/sbp_util.h

diff --git a/drivers/target/sbp/sbp_util.c b/drivers/target/sbp/sbp_util.c
new file mode 100644
index 0000000..33073b1
--- /dev/null
+++ b/drivers/target/sbp/sbp_util.c
@@ -0,0 +1,36 @@
+/*
+ * SBP2 target driver (SCSI over IEEE1394 in target mode)
+ *
+ * Copyright (C) 2011  Chris Boot <bootc@bootc.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#define KMSG_COMPONENT "sbp_target"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
+
+#include <target/target_core_base.h>
+
+#include "sbp_base.h"
+#include "sbp_util.h"
+
+const struct fw_address_region sbp_register_region = {
+	.start = CSR_REGISTER_BASE + 0x10000,
+	.end   = 0x1000000000000ULL,
+};
+
diff --git a/drivers/target/sbp/sbp_util.h b/drivers/target/sbp/sbp_util.h
new file mode 100644
index 0000000..cd3e00d
--- /dev/null
+++ b/drivers/target/sbp/sbp_util.h
@@ -0,0 +1,15 @@
+
+extern const struct fw_address_region sbp_register_region;
+
+static inline u64 sbp2_pointer_to_addr(const struct sbp2_pointer *ptr)
+{
+	return (u64)(be32_to_cpu(ptr->high) & 0x0000ffff) << 32 |
+		(be32_to_cpu(ptr->low) & 0xfffffffc);
+}
+
+static inline void addr_to_sbp2_pointer(u64 addr, struct sbp2_pointer *ptr)
+{
+	ptr->high = cpu_to_be32(addr >> 32);
+	ptr->low = cpu_to_be32(addr);
+}
+
-- 
1.7.9

