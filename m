Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2HBRPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:15:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2HBRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:15:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Arun Raghavan <arun.raghavan@collabora.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] apple-gmux: Fix kconfig dependencies
Date: Thu,  2 Aug 2012 12:15:14 -0500
Message-Id: <1343927714-14937-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
References: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the dependencies of apple-gmux to prevent it from being built-in
when one or more of its dependencies is built as a module. Otherwise it
can fail to build due to missing symbols.

v2: Add dependency on ACPI to fix build failure when ACPI=n

Reported-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2a262f5..637074d 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -758,8 +758,11 @@ config SAMSUNG_Q10
 
 config APPLE_GMUX
 	tristate "Apple Gmux Driver"
+	depends on ACPI
 	depends on PNP
-	select BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_APPLE=n || BACKLIGHT_APPLE
+	depends on ACPI_VIDEO=n || ACPI_VIDEO
 	---help---
 	  This driver provides support for the gmux device found on many
 	  Apple laptops, which controls the display mux for the hybrid
-- 
1.7.9.5

