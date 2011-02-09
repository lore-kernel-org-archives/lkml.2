Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1BIATj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:19:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:58012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab1BIARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:17:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,444,1291622400"; 
   d="scan'208";a="705558314"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 06/12] PTI header file.
Date: Tue,  8 Feb 2011 16:17:11 -0800
Message-Id: <1297210637-5934-6-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297210637-5934-5-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297210637-5934-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-5-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This adds PTI header information for the PTI project.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 include/linux/pti.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pti.h

diff --git a/include/linux/pti.h b/include/linux/pti.h
new file mode 100644
index 0000000..4b1c9f6
--- /dev/null
+++ b/include/linux/pti.h
@@ -0,0 +1,38 @@
+/*
+ *  Copyright (C) Intel 2010
+ *  Ken Mills <ken.k.mills@intel.com>
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA
+ *
+ */
+
+#ifndef PTI_H_
+#define PTI_H_
+
+/* basic structure used as a write address to the PTI HW */
+struct masterchannel {
+	u8 master;
+	u8 channel;
+};
+
+/* the following functions are defined in misc/pti.c */
+void mipi_pti_writedata(struct masterchannel *mc, u8 *cp, int count);
+struct masterchannel *mipi_request_masterchannel(u8 kerneluser);
+void mipi_release_masterchannel(struct masterchannel *mc);
+
+#define APERTURE_14 0x3800000
+#define APERTURE_LEN 0x400000
+
+#endif /*PTI_H_*/
-- 
1.6.6.1

