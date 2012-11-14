Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161018Ab2KNJmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:42:47 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:45829 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab2KNJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:42:37 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 10/10] vga: compile fix, disable vga for s390
Date: Wed, 14 Nov 2012 10:41:42 +0100
Message-Id: <65c7c355e98193fbf866edc3edfe429d5f59047e.1352719878.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
x-cbid: 12111409-5024-0000-0000-0000045AFA9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 drivers/gpu/vga/Kconfig | 2 +-
 include/video/vga.h     | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/vga/Kconfig b/drivers/gpu/vga/Kconfig
index f348388..29437ea 100644
--- a/drivers/gpu/vga/Kconfig
+++ b/drivers/gpu/vga/Kconfig
@@ -1,7 +1,7 @@
 config VGA_ARB
 	bool "VGA Arbitration" if EXPERT
 	default y
-	depends on PCI
+	depends on (PCI && !S390)
 	help
 	  Some "legacy" VGA devices implemented on PCI typically have the same
 	  hard-decoded addresses as they did on ISA. When multiple PCI devices
diff --git a/include/video/vga.h b/include/video/vga.h
index cac567f..7978d31 100644
--- a/include/video/vga.h
+++ b/include/video/vga.h
@@ -19,7 +19,9 @@
 
 #include <linux/types.h>
 #include <asm/io.h>
+#ifndef __s390x__
 #include <asm/vga.h>
+#endif
 #include <asm/byteorder.h>
 
 
-- 
1.7.12.4

