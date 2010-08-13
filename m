Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590Ab0HMNJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:09:49 -0400
Received: from king.tilera.com ([72.1.168.226]:13968 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575Ab0HMNJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:09:47 -0400
Message-Id: <201008131309.o7DD9kp6005837@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 08:23:07 -0400
Subject: [PATCH] arch/tile: correct a bug in freeing bootmem by VA for the optional second initrd.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 13 Aug 2010 13:09:46.0500 (UTC) FILETIME=[CD841440:01CB3AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 4dd21c1..e7d54c7 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -953,7 +953,7 @@ static void __init load_hv_initrd(void)
 	if (rc != stat.size) {
 		pr_err("Error reading %d bytes from hvfs file '%s': %d\n",
 		       stat.size, initramfs_file, rc);
-		free_bootmem((unsigned long) initrd, stat.size);
+		free_initrd_mem((unsigned long) initrd, stat.size);
 		return;
 	}
 	initrd_start = (unsigned long) initrd;
@@ -962,7 +962,7 @@ static void __init load_hv_initrd(void)
 
 void __init free_initrd_mem(unsigned long begin, unsigned long end)
 {
-	free_bootmem(begin, end - begin);
+	free_bootmem(__pa(begin), end - begin);
 }
 
 static void __init validate_hv(void)
-- 
1.6.5.2

