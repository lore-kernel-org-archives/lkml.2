Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1ALVE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:04:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab1ALVEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:04:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] ACPI / PM: Fix build problems for !CONFIG_ACPI related to NVS rework
Date: Wed, 12 Jan 2011 22:03:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20110112141822.c29314c4.sfr@canb.auug.org.au> <201101122135.55567.rjw@sisk.pl> <4D2E13C9.7030704@oracle.com>
In-Reply-To: <4D2E13C9.7030704@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101122203.20657.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The recent rework of the NVS saving/restoring code introduced two
build issues for !CONFIG_ACPI, a warning in drivers/acpi/internal.h
and an error in arch/x86/kernel/e820.c.

Fix them by providing suitable static inline definitions of the
relevant functions.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/internal.h |    2 +-
 include/linux/acpi.h    |   19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -91,7 +91,7 @@ void suspend_nvs_restore(void);
 static inline int acpi_sleep_proc_init(void) { return 0; }
 static inline int suspend_nvs_alloc(void) { return 0; }
 static inline void suspend_nvs_free(void) {}
-static inline int suspend_nvs_save(void) {}
+static inline int suspend_nvs_save(void) { return 0; }
 static inline void suspend_nvs_restore(void) {}
 #endif
 
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -254,15 +254,6 @@ void __init acpi_old_suspend_ordering(vo
 void __init acpi_nvs_nosave(void);
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_ACPI_SLEEP
-int suspend_nvs_register(unsigned long start, unsigned long size);
-#else
-static inline int suspend_nvs_register(unsigned long a, unsigned long b)
-{
-	return 0;
-}
-#endif
-
 struct acpi_osc_context {
 	char *uuid_str; /* uuid string */
 	int rev;
@@ -361,4 +352,14 @@ static inline int acpi_table_parse(char
 	return -1;
 }
 #endif	/* !CONFIG_ACPI */
+
+#ifdef CONFIG_ACPI_SLEEP
+int suspend_nvs_register(unsigned long start, unsigned long size);
+#else
+static inline int suspend_nvs_register(unsigned long a, unsigned long b)
+{
+	return 0;
+}
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
