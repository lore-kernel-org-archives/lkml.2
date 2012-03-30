Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab2C3KPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:15:07 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:39314 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760683Ab2C3KOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:14:49 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 03/76] ACPI: ignore FADT reset-reg-sup flag
Date: Fri, 30 Mar 2012 06:13:06 -0400
Message-id: <cf450136bfde77c7f95065c91bffded4aa7fa731.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

we check that the address is non-zero later anyway.

https://bugzilla.kernel.org/show_bug.cgi?id=11533

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/hwxface.c |    3 +--
 drivers/acpi/reboot.c         |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 9d38eb6..fe1fb63 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -74,8 +74,7 @@ acpi_status acpi_reset(void)
 
 	/* Check if the reset register is supported */
 
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
-	    !reset_reg->address) {
+	if (!reset_reg->address) {
 		return_ACPI_STATUS(AE_NOT_EXIST);
 	}
 
diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index a6c77e8b..c1d6124 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -23,8 +23,7 @@ void acpi_reboot(void)
 	/* Is the reset register supported? The spec says we should be
 	 * checking the bit width and bit offset, but Windows ignores
 	 * these fields */
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER))
-		return;
+	/* Ignore also acpi_gbl_FADT.flags.ACPI_FADT_RESET_REGISTER */
 
 	reset_value = acpi_gbl_FADT.reset_value;
 
-- 
1.7.10.rc2.19.gfae9d

