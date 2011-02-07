Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1BGWX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:23:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab1BGWXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:23:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/6] ACPI / PM: Drop acpi_restore_state_mem()
Date: Mon, 7 Feb 2011 23:18:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <201102072316.41270.rjw@sisk.pl>
In-Reply-To: <201102072316.41270.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072318.02829.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The function acpi_restore_state_mem() has never been and most likely
never will be used, so remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/ia64/include/asm/acpi.h |    4 ++--
 arch/ia64/kernel/acpi.c      |    5 -----
 arch/x86/include/asm/acpi.h  |    3 +--
 arch/x86/kernel/acpi/sleep.c |    8 --------
 drivers/acpi/sleep.c         |    4 ----
 5 files changed, 3 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -293,10 +293,6 @@ static int acpi_suspend_enter(suspend_st
 	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
 
-	/* restore processor state */
-	if (acpi_state == ACPI_STATE_S3)
-		acpi_restore_state_mem();
-
 	suspend_nvs_restore();
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
Index: linux-2.6/arch/ia64/include/asm/acpi.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/acpi.h
+++ linux-2.6/arch/ia64/include/asm/acpi.h
@@ -128,9 +128,9 @@ static inline const char *acpi_get_sysna
 int acpi_request_vector (u32 int_type);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
-/* routines for saving/restoring kernel state */
+/* Routine for saving kernel state during suspend. */
 extern int acpi_save_state_mem(void);
-extern void acpi_restore_state_mem(void);
+
 extern unsigned long acpi_wakeup_address;
 
 /*
Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -1041,11 +1041,6 @@ EXPORT_SYMBOL(acpi_unregister_ioapic);
 int acpi_save_state_mem(void) { return 0; } 
 
 /*
- * acpi_restore_state()
- */
-void acpi_restore_state_mem(void) {}
-
-/*
  * do_suspend_lowlevel()
  */
 void do_suspend_lowlevel(void) {}
Index: linux-2.6/arch/x86/include/asm/acpi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/acpi.h
+++ linux-2.6/arch/x86/include/asm/acpi.h
@@ -112,9 +112,8 @@ static inline void acpi_disable_pci(void
 	acpi_noirq_set();
 }
 
-/* routines for saving/restoring kernel state */
+/* Routine for saving kernel state during suspend. */
 extern int acpi_save_state_mem(void);
-extern void acpi_restore_state_mem(void);
 
 extern unsigned long acpi_wakeup_address;
 
Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6/arch/x86/kernel/acpi/sleep.c
@@ -112,14 +112,6 @@ int acpi_save_state_mem(void)
 	return 0;
 }
 
-/*
- * acpi_restore_state - undo effects of acpi_save_state_mem
- */
-void acpi_restore_state_mem(void)
-{
-}
-
-
 /**
  * acpi_reserve_wakeup_memory - do _very_ early ACPI initialisation
  *

