Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2JFUNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:13:24 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35259 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2JFUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:13:14 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 11/49] ACPICA: Add struct header support for _FDE, _GRT, _GTM, and _SRT names.
Date: Sat,  6 Oct 2012 16:09:32 -0400
Message-Id: <84be5d687f8060ad96d5a4a060e207a0ec5cc016.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Added structs for the buffers related to these predefined names,
in acbuffer.h

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/acbuffer.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/acpi/acbuffer.h b/include/acpi/acbuffer.h
index 2c3b447..a1e45cd 100644
--- a/include/acpi/acbuffer.h
+++ b/include/acpi/acbuffer.h
@@ -45,6 +45,11 @@
 #define __ACBUFFER_H__
 
 /*
+ * Contains buffer structures for these predefined names:
+ * _FDE, _GRT, _GTM, _PLD, _SRT
+ */
+
+/*
  * Note: C bitfields are not used for this reason:
  *
  * "Bitfields are great and easy to read, but unfortunately the C language
@@ -56,6 +61,44 @@
  * See http://stackoverflow.com/a/1053662/41661
  */
 
+/* _FDE return value */
+
+struct acpi_fde_info {
+	u32 floppy0;
+	u32 floppy1;
+	u32 floppy2;
+	u32 floppy3;
+	u32 tape;
+};
+
+/*
+ * _GRT return value
+ * _SRT input value
+ */
+struct acpi_grt_info {
+	u16 year;
+	u8 month;
+	u8 day;
+	u8 hour;
+	u8 minute;
+	u8 second;
+	u8 valid;
+	u16 milliseconds;
+	u16 timezone;
+	u8 daylight;
+	u8 reserved[3];
+};
+
+/* _GTM return value */
+
+struct acpi_gtm_info {
+	u32 pio_speed0;
+	u32 dma_speed0;
+	u32 pio_speed1;
+	u32 dma_speed1;
+	u32 flags;
+};
+
 /*
  * Formatted _PLD return value. The minimum size is a package containing
  * one buffer.
-- 
1.8.0.rc0.18.gf84667d

