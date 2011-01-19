Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1ASFP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:15:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab1ASFPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:15:54 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION),
        Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM),
        Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM),
        "Rafael J. Wysocki" <rjw@sisk.pl> (supporter:SUSPEND TO RAM),
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
Subject: [Patch] acpi: remove acpi_sleep=s4_nonvs
Date: Wed, 19 Jan 2011 13:14:06 +0800
Message-Id: <1295414046-14257-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_sleep=s4_nonvs is superseded by acpi_sleep=nonvs.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 8c594c4..247582c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -521,14 +521,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de>
 
 ----------------------------
 
-What:	The acpi_sleep=s4_nonvs command line option
-When:	2.6.37
-Files:	arch/x86/kernel/acpi/sleep.c
-Why:	superseded by acpi_sleep=nonvs
-Who:	Rafael J. Wysocki <rjw@sisk.pl>
-
-----------------------------
-
 What: 	PCI DMA unmap state API
 When:	August 2012
 Why:	PCI DMA unmap state API (include/linux/pci-dma.h) was replaced
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b72e071..64d907d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -240,7 +240,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	acpi_sleep=	[HW,ACPI] Sleep options
 			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
-				  old_ordering, s4_nonvs, sci_force_enable }
+				  old_ordering, nonvs, sci_force_enable }
 			See Documentation/power/video.txt for information on
 			s3_bios and s3_mode.
 			s3_beep is for debugging; it makes the PC's speaker beep
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 69fd72a..bb9f327 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -162,11 +162,6 @@ static int __init acpi_sleep_setup(char *str)
 #ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
-		if (strncmp(str, "s4_nonvs", 8) == 0) {
-			pr_warning("ACPI: acpi_sleep=s4_nonvs is deprecated, "
-					"please use acpi_sleep=nonvs instead");
-			acpi_nvs_nosave();
-		}
 #endif
 		if (strncmp(str, "nonvs", 5) == 0)
 			acpi_nvs_nosave();
