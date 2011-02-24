Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1BXSJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:09:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:59766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1BXSHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:07:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,219,1297065600"; 
   d="scan'208";a="890936977"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 05/10] PTI header file.
Date: Thu, 24 Feb 2011 10:06:59 -0800
Message-Id: <1298570824-26085-6-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This adds PTI header information for the PTI project.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 include/linux/pti.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pti.h

diff --git a/include/linux/pti.h b/include/linux/pti.h
new file mode 100644
index 0000000..94d05bc
--- /dev/null
+++ b/include/linux/pti.h
@@ -0,0 +1,39 @@
+/*
+ *  Copyright (C) Intel 2011
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * The PTI (Parallel Trace Interface) driver directs trace data routed from
+ * various parts in the system out through the Intel Penwell PTI port and
+ * out of the mobile device for analysis with a debugging tool
+ * (Lauterbach, Fido). This is part of a solution for the MIPI P1149.7,
+ * compact JTAG, standard.
+ *
+ * This header file will allow other parts of the OS to use the
+ * interface to write out it's contents for debugging a mobile system.
+ */
+
+#ifndef PTI_H_
+#define PTI_H_
+
+/* basic structure used as a write address to the PTI HW */
+struct pti_masterchannel {
+	u8 master;
+	u8 channel;
+};
+
+/* the following functions are defined in misc/pti.c */
+void pti_writedata(struct pti_masterchannel *mc, u8 *buf, int count);
+struct pti_masterchannel *pti_request_masterchannel(u8 type);
+void pti_release_masterchannel(struct pti_masterchannel *mc);
+
+#endif /*PTI_H_*/
-- 
1.7.2.3

