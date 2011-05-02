Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1EBXJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:42 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab1EBXJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:32 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsQ8S030356@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 15:51:32 -0400
Subject: [PATCH] arch/tile: tolerate disabling CONFIG_BLK_DEV_INITRD
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:26.0768 (UTC) FILETIME=[E336AD00:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code accidentally was relying on this configuration option
being selected.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 3696b18..6cdc9ba 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -912,6 +912,8 @@ void __cpuinit setup_cpu(int boot)
 #endif
 }
 
+#ifdef CONFIG_BLK_DEV_INITRD
+
 static int __initdata set_initramfs_file;
 static char __initdata initramfs_file[128] = "initramfs.cpio.gz";
 
@@ -969,6 +971,10 @@ void __init free_initrd_mem(unsigned long begin, unsigned long end)
 	free_bootmem(__pa(begin), end - begin);
 }
 
+#else
+static inline void load_hv_initrd(void) {}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 static void __init validate_hv(void)
 {
 	/*
-- 
1.6.5.2

