Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2JFUMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:12:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63538 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2JFUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:12:37 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 08/49] ACPICA: GPE support: Remove extraneous parameter from low-level function.
Date: Sat,  6 Oct 2012 16:09:29 -0400
Message-Id: <1d94e1e8ba9d466c707f1bcb32494ca7daefb644.1349554105.git.len.brown@intel.com>
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

From: Feng Tang <feng.tang@intel.com>

The gpe_register_info argument is no longer needed, reduce it to
make code simpler.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/achware.h |  3 +--
 drivers/acpi/acpica/evgpe.c   |  3 +--
 drivers/acpi/acpica/evxfgpe.c |  3 +--
 drivers/acpi/acpica/hwgpe.c   | 15 +++++----------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index 5de4ec7..d902d31 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -110,8 +110,7 @@ acpi_status acpi_hw_write_port(acpi_io_address address, u32 value, u32 width);
 /*
  * hwgpe - GPE support
  */
-u32 acpi_hw_get_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info,
-			     struct acpi_gpe_register_info *gpe_register_info);
+u32 acpi_hw_get_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info);
 
 acpi_status
 acpi_hw_low_set_gpe(struct acpi_gpe_event_info *gpe_event_info, u32 action);
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 3db3c56..ef0193d 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -80,8 +80,7 @@ acpi_ev_update_gpe_enable_mask(struct acpi_gpe_event_info *gpe_event_info)
 		return_ACPI_STATUS(AE_NOT_EXIST);
 	}
 
-	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info,
-						gpe_register_info);
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
 
 	/* Clear the run bit up front */
 
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 6affbdb..87c5f23 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -357,8 +357,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_device, u32 gpe_number, u8 ac
 		goto unlock_and_exit;
 	}
 
-	register_bit =
-	    acpi_hw_get_gpe_register_bit(gpe_event_info, gpe_register_info);
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
 
 	/* Perform the action */
 
diff --git a/drivers/acpi/acpica/hwgpe.c b/drivers/acpi/acpica/hwgpe.c
index 25bd28c..db40765 100644
--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -60,7 +60,6 @@ acpi_hw_enable_wakeup_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
  * FUNCTION:	acpi_hw_get_gpe_register_bit
  *
  * PARAMETERS:	gpe_event_info	    - Info block for the GPE
- *		gpe_register_info   - Info block for the GPE register
  *
  * RETURN:	Register mask with a one in the GPE bit position
  *
@@ -69,11 +68,10 @@ acpi_hw_enable_wakeup_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
  *
  ******************************************************************************/
 
-u32 acpi_hw_get_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info,
-			     struct acpi_gpe_register_info *gpe_register_info)
+u32 acpi_hw_get_gpe_register_bit(struct acpi_gpe_event_info *gpe_event_info)
 {
 	return (u32)1 << (gpe_event_info->gpe_number -
-				gpe_register_info->base_gpe_number);
+		 gpe_event_info->register_info->base_gpe_number);
 }
 
 /******************************************************************************
@@ -115,8 +113,7 @@ acpi_hw_low_set_gpe(struct acpi_gpe_event_info *gpe_event_info, u32 action)
 
 	/* Set or clear just the bit that corresponds to this GPE */
 
-	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info,
-						gpe_register_info);
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
 	switch (action) {
 	case ACPI_GPE_CONDITIONAL_ENABLE:
 
@@ -178,8 +175,7 @@ acpi_status acpi_hw_clear_gpe(struct acpi_gpe_event_info * gpe_event_info)
 	 * Write a one to the appropriate bit in the status register to
 	 * clear this GPE.
 	 */
-	register_bit =
-	    acpi_hw_get_gpe_register_bit(gpe_event_info, gpe_register_info);
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
 
 	status = acpi_hw_write(register_bit,
 			       &gpe_register_info->status_address);
@@ -222,8 +218,7 @@ acpi_hw_get_gpe_status(struct acpi_gpe_event_info * gpe_event_info,
 
 	/* Get the register bitmask for this GPE */
 
-	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info,
-						gpe_register_info);
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
 
 	/* GPE currently enabled? (enabled for runtime?) */
 
-- 
1.8.0.rc0.18.gf84667d

