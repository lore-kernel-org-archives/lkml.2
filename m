Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2IWEfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:35:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41520 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2IWEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:34:55 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 11/23] ACPICA: Add struct header support for _FDE, _GRT, _GTM, and _SRT names.
Date: Sun, 23 Sep 2012 00:33:59 -0400
Message-Id: <84be5d687f8060ad96d5a4a060e207a0ec5cc016.1348371388.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.1.396.g16eed7c
In-Reply-To: <1348374851-20378-1-git-send-email-lenb@kernel.org>
References: <1348374851-20378-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
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
1.7.12.1.396.g16eed7c

