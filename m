Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1GPXQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 19:16:34 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:39535 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1GPXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 19:16:33 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jul 2011 19:16:33 EDT
Date: Sat, 16 Jul 2011 18:16:20 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: APEI build fix
In-reply-to: <20110716120304.83d79985.rdunlap@xenotime.net>
Message-id: <alpine.LFD.2.02.1107161815220.4339@x980>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
 <20110716120304.83d79985.rdunlap@xenotime.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

as GHES is optional...

When # CONFIG_ACPI_APEI_GHES is not set:

(.init.text+0x4c22): undefined reference to `ghes_disable'

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
1.7.6.178.g55272


