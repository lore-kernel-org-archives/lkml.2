Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2JRJ4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:56:04 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36088 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2JRJ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:56:02 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2 RESEND RFC] Make IKCONFIG an embedded option, enabled by default
Date: Thu, 18 Oct 2012 11:55:50 +0200
Message-Id: <1350554151-8767-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Knowing (being sure) which configuration was used to build a (maybe running)
kernel is important for many scenarios.

It's usually much more important than saving a few kb in the size of
the kernel. Therefor turn on CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC
by default and make them visible only when CONFIG_EMBEDDED is enabled,
preventing premature optimization.

Because I just have seen too many systems where the used config got lost
and people were unable to rebuild an updated kernel, I finally prepared
this patch. IKCONFIG is already enabled in most distributions and
embedded kernels.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 init/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..add21a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -658,7 +658,8 @@ config RCU_BOOST_DELAY
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
-	tristate "Kernel .config support"
+	tristate "Kernel .config support" if EMBEDDED
+	default y
 	---help---
 	  This option enables the complete Linux kernel ".config" file
 	  contents to be saved in the kernel. It provides documentation
@@ -670,8 +671,9 @@ config IKCONFIG
 	  /proc/config.gz if enabled (below).
 
 config IKCONFIG_PROC
-	bool "Enable access to .config through /proc/config.gz"
+	bool "Enable access to .config through /proc/config.gz" if EMBEDDED
 	depends on IKCONFIG && PROC_FS
+	default y
 	---help---
 	  This option enables access to the kernel configuration file
 	  through /proc/config.gz.
-- 
1.7.11.7

