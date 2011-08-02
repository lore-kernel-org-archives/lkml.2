Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1HBWwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:52:01 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:41638 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1HBWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:51:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Subject: [PATCH 17/19] ACPI: APEI build fix
Date: Tue, 02 Aug 2011 18:14:50 -0400
Message-id: <785d8abb8ac20eeb48db31e5d41b06a1ea3714ca.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

as GHES is optional...

When # CONFIG_ACPI_APEI_GHES is not set:

(.init.text+0x4c22): undefined reference to `ghes_disable'

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/bus.c  |    2 --
 include/acpi/apei.h |    4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 43ce3b0..437ddbf 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -544,10 +544,8 @@ static void acpi_bus_osc_support(void)
 	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
 #endif
 
-#ifdef CONFIG_ACPI_APEI_GHES
 	if (!ghes_disable)
 		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
-#endif
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
 		return;
 	if (ACPI_SUCCESS(acpi_run_osc(handle, &context))) {
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index d40bc55..51a527d 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -18,7 +18,11 @@
 
 extern int hest_disable;
 extern int erst_disable;
+#ifdef CONFIG_ACPI_APEI_GHES
 extern int ghes_disable;
+#else
+#define ghes_disable 1
+#endif
 
 #ifdef CONFIG_ACPI_APEI
 void __init acpi_hest_init(void);
-- 
1.7.6.396.ge0613

