Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0JAHGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:30 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45258 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab0JAHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:26 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 05/18] powerpc: Wire up 44x little endian boot for remaining 44x targets
Date: Fri,  1 Oct 2010 17:05:58 +1000
Message-Id: <1285916771-18033-6-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

I haven't tested booting a little endian kernel on any of these targets,
but they all claim to be 44x so my little endian trampoline should work
on all of them, so wire it up on:

bamboo
katmai
kilauea
rainer
sam440ep
sequoia
warp
yosemite
ebony

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/boot/bamboo.c          |    1 +
 arch/powerpc/boot/cuboot-katmai.c   |    1 +
 arch/powerpc/boot/cuboot-kilauea.c  |    1 +
 arch/powerpc/boot/cuboot-rainier.c  |    1 +
 arch/powerpc/boot/cuboot-sam440ep.c |    1 +
 arch/powerpc/boot/cuboot-sequoia.c  |    1 +
 arch/powerpc/boot/cuboot-warp.c     |    1 +
 arch/powerpc/boot/cuboot-yosemite.c |    1 +
 arch/powerpc/boot/ebony.c           |    1 +
 9 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/bamboo.c b/arch/powerpc/boot/bamboo.c
index b82cacb..547494b 100644
--- a/arch/powerpc/boot/bamboo.c
+++ b/arch/powerpc/boot/bamboo.c
@@ -41,6 +41,7 @@ void bamboo_init(void *mac0, void *mac1)
 {
 	platform_ops.fixups = bamboo_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	bamboo_mac0 = mac0;
 	bamboo_mac1 = mac1;
 	fdt_init(_dtb_start);
diff --git a/arch/powerpc/boot/cuboot-katmai.c b/arch/powerpc/boot/cuboot-katmai.c
index 5434d70..c72bdbf 100644
--- a/arch/powerpc/boot/cuboot-katmai.c
+++ b/arch/powerpc/boot/cuboot-katmai.c
@@ -52,6 +52,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	CUBOOT_INIT();
 
 	platform_ops.fixups = katmai_fixups;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/cuboot-kilauea.c b/arch/powerpc/boot/cuboot-kilauea.c
index 80cdad6..115048a 100644
--- a/arch/powerpc/boot/cuboot-kilauea.c
+++ b/arch/powerpc/boot/cuboot-kilauea.c
@@ -44,6 +44,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	CUBOOT_INIT();
 	platform_ops.fixups = kilauea_fixups;
 	platform_ops.exit = ibm40x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/cuboot-rainier.c b/arch/powerpc/boot/cuboot-rainier.c
index 0a3fdde..7c1ad02 100644
--- a/arch/powerpc/boot/cuboot-rainier.c
+++ b/arch/powerpc/boot/cuboot-rainier.c
@@ -52,6 +52,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	CUBOOT_INIT();
 	platform_ops.fixups = rainier_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/cuboot-sam440ep.c b/arch/powerpc/boot/cuboot-sam440ep.c
index ec10a47..60761fd 100644
--- a/arch/powerpc/boot/cuboot-sam440ep.c
+++ b/arch/powerpc/boot/cuboot-sam440ep.c
@@ -44,6 +44,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	CUBOOT_INIT();
 	platform_ops.fixups = sam440ep_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/cuboot-sequoia.c b/arch/powerpc/boot/cuboot-sequoia.c
index caf8f2e..3e93748 100644
--- a/arch/powerpc/boot/cuboot-sequoia.c
+++ b/arch/powerpc/boot/cuboot-sequoia.c
@@ -52,6 +52,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	CUBOOT_INIT();
 	platform_ops.fixups = sequoia_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/cuboot-warp.c b/arch/powerpc/boot/cuboot-warp.c
index 806df69..8bdc383 100644
--- a/arch/powerpc/boot/cuboot-warp.c
+++ b/arch/powerpc/boot/cuboot-warp.c
@@ -33,6 +33,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 
 	platform_ops.fixups = warp_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/cuboot-yosemite.c b/arch/powerpc/boot/cuboot-yosemite.c
index cc6e338..7fe0e05 100644
--- a/arch/powerpc/boot/cuboot-yosemite.c
+++ b/arch/powerpc/boot/cuboot-yosemite.c
@@ -39,6 +39,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	CUBOOT_INIT();
 	platform_ops.fixups = yosemite_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	fdt_init(_dtb_start);
 	serial_console_init();
 }
diff --git a/arch/powerpc/boot/ebony.c b/arch/powerpc/boot/ebony.c
index 5532ab3..6f302aa 100644
--- a/arch/powerpc/boot/ebony.c
+++ b/arch/powerpc/boot/ebony.c
@@ -85,6 +85,7 @@ void ebony_init(void *mac0, void *mac1)
 {
 	platform_ops.fixups = ebony_fixups;
 	platform_ops.exit = ibm44x_dbcr_reset;
+	platform_ops.le_kentry = ibm44x_le_kentry;
 	ebony_mac0 = mac0;
 	ebony_mac1 = mac1;
 	fdt_init(_dtb_start);
-- 
1.7.1

