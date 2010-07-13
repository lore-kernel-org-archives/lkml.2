Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0GMOGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:06:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47688 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab0GMOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:05:59 -0400
Message-ID: <4C3C72C6.4000005@canonical.com>
Date: Tue, 13 Jul 2010 15:05:58 +0100
From: Lee Jones <lee.jones@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linuxfoundation.org
Subject: [PATCH] Stop ARM boards crashing when CUPS is loaded - 2.6.35-rc5
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 219005d9522043bc42ddb51d59688959eed0d443 Mon Sep 17 00:00:00 2001
From: Lee Jones <lee.jones@canonical.com>
Date: Tue, 13 Jul 2010 15:02:17 +0100
Subject: [PATCH] UBUNTU: [Upstream] Stop ARM boards crashing when CUPS is loaded

BugLink: http://bugs.launchpad.net/bugs/601226

When CUPS loads, it tries to load several drivers that it may need.
When one of these drivers, specifically parport_pc is loaded on ARM
based systems, it causes a segmentation fault as the ISA addresses
which are attempted are not writable on non-PC based architectures.
This code prevents ISA addresses from being attempted except on x86.

Signed-off-by: Lee Jones <lee.jones@canonical.com>
---
 arch/arm/include/asm/parport.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/parport.h b/arch/arm/include/asm/parport.h
index 26e94b0..a1874f8 100644
--- a/arch/arm/include/asm/parport.h
+++ b/arch/arm/include/asm/parport.h
@@ -9,10 +9,13 @@
 #ifndef __ASMARM_PARPORT_H
 #define __ASMARM_PARPORT_H
 
-static int __devinit parport_pc_find_isa_ports (int autoirq, int autodma);
 static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
 {
-	return parport_pc_find_isa_ports (autoirq, autodma);
+/* parport_pc_find_isa_ports uses direct register addresses which are
+ * only correct on x86 architectures. This may have undesirable
+ * consequences (including segfaults) when used on other architectures.
+ */
+	return 0;
 }
 
 #endif /* !(_ASMARM_PARPORT_H) */
-- 
1.7.0.4
