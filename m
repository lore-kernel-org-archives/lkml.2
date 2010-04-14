Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0DNEzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:55:48 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:11463 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0DNEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:55:45 -0400
X-Spam-Processed: digidescorp.com, Tue, 13 Apr 2010 23:55:44 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.37.252
X-Return-Path: prvs=1720206d9c=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH 2/2] microblaze: allow developer selection of STACKTRACE
Date: Tue, 13 Apr 2010 23:55:38 -0500
Message-Id: <1271220938-3526-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the developer to configure STACKTRACE to enable userland access to backtraces in /proc/NN/stack.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig	2010-04-09 21:52:36.000000000 -0500
+++ b/arch/microblaze/Kconfig	2010-04-12 22:16:01.000000000 -0500
@@ -136,6 +136,14 @@ config PROC_DEVICETREE
 	  an image of the device tree that the kernel copies from Open
 	  Firmware or other boot firmware. If unsure, say Y here.
 
+config PROC_BACKTRACE
+	bool "Support for kernel backtraces in /proc/NN/stack"
+	default n
+	select STACKTRACE
+	help
+	  This option adds a backtrace of the kernel stack to /proc/NN/stack.
+	  If unsure, say N here.
+
 endmenu
 
 menu "Advanced setup"


