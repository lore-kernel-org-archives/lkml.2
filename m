Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2IWEfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:35:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2IWEek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:34:40 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 06/23] ACPICA: GPE Support: Update debug info for GPE tracing.
Date: Sun, 23 Sep 2012 00:33:54 -0400
Message-Id: <e1154ebd4d0215937528016c41e2f13d30a28082.1348371388.git.len.brown@intel.com>
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

Add additional debug info to assist with GPE debugging.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/evgpe.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index afbd5cb..3db3c56 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -379,6 +379,18 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 			 */
 			if (!(gpe_register_info->enable_for_run |
 			      gpe_register_info->enable_for_wake)) {
+				ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
+						  "Ignore disabled registers for GPE%02X-GPE%02X: "
+						  "RunEnable=%02X, WakeEnable=%02X\n",
+						  gpe_register_info->
+						  base_gpe_number,
+						  gpe_register_info->
+						  base_gpe_number +
+						  (ACPI_GPE_REGISTER_WIDTH - 1),
+						  gpe_register_info->
+						  enable_for_run,
+						  gpe_register_info->
+						  enable_for_wake));
 				continue;
 			}
 
@@ -401,9 +413,14 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 			}
 
 			ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
-					  "Read GPE Register at GPE%02X: Status=%02X, Enable=%02X\n",
+					  "Read registers for GPE%02X-GPE%02X: Status=%02X, Enable=%02X, "
+					  "RunEnable=%02X, WakeEnable=%02X\n",
 					  gpe_register_info->base_gpe_number,
-					  status_reg, enable_reg));
+					  gpe_register_info->base_gpe_number +
+					  (ACPI_GPE_REGISTER_WIDTH - 1),
+					  status_reg, enable_reg,
+					  gpe_register_info->enable_for_run,
+					  gpe_register_info->enable_for_wake));
 
 			/* Check if there is anything active at all in this register */
 
-- 
1.7.12.1.396.g16eed7c

