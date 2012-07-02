Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2GBOzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:55:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2GBOzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:55:40 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] apple-gmux: Fix kconfig dependencies
Date: Mon,  2 Jul 2012 09:55:29 -0500
Message-Id: <1341240929-3400-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the dependencies of apple-gmux to prevent it from being built-in
when one or more of its dependencies is built as a module. Otherwise it
can fail to build due to missing symbols.

Reported-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2a262f5..cf65f0a 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -759,7 +759,9 @@ config SAMSUNG_Q10
 config APPLE_GMUX
 	tristate "Apple Gmux Driver"
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

