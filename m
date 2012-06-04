Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2FDFku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:50 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54747 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2FDFkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:42 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 14/15] drivers: acpi: Fix dependency for ACPI_HOTPLUG_CPU
Date: Mon,  4 Jun 2012 01:40:05 -0400
Message-Id: <2f07a6134f670755e6ce657d019c26305bfcef89.1338786832.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

Fix the following build warning:

warning: (ACPI_HOTPLUG_CPU) selects ACPI_CONTAINER which has unmet direct dependencies (ACPI && EXPERIMENTAL)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 47768ff..8099895 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -208,7 +208,7 @@ config ACPI_IPMI
 
 config ACPI_HOTPLUG_CPU
 	bool
-	depends on ACPI_PROCESSOR && HOTPLUG_CPU
+	depends on EXPERIMENTAL && ACPI_PROCESSOR && HOTPLUG_CPU
 	select ACPI_CONTAINER
 	default y
 
-- 
1.7.11.rc0.100.g5498c5f

