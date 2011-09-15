Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab1IOUKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:61479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934730Ab1IOUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873432"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH 09/27] Initconst section fixes for X86
Date: Thu, 15 Sep 2011 13:09:36 -0700
Message-Id: <1316117394-21666-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/rtc.c                |    2 +-
 drivers/platform/x86/dell-laptop.c   |    2 +-
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 3f2ad26..f8894c4 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -222,7 +222,7 @@ static struct platform_device rtc_device = {
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char *ids[] __initconst =
+	static const char * const  const ids[] __initconst =
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index f31fa4e..eb53f7a 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -78,7 +78,7 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static const struct dmi_system_id __initdata dell_device_table[] = {
+static const struct dmi_system_id __initconst dell_device_table[] = {
 	{
 		.ident = "Dell laptop",
 		.matches = {
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7bd829f..394f8a7 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -522,7 +522,7 @@ static acpi_handle ec_handle;
 
 #define TPACPI_HANDLE(object, parent, paths...)			\
 	static acpi_handle  object##_handle;			\
-	static const acpi_handle *object##_parent __initdata =	\
+	static const acpi_handle * const object##_parent __initconst =	\
 						&parent##_handle; \
 	static char *object##_paths[] __initdata = { paths }
 
-- 
1.7.4.4

