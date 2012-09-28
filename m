Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423145Ab2I1VEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:04:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42085 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032935Ab2I1Uq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:46:59 -0400
X-Sasl-enc: J9vkZzTxmcCLwkc5TUOC67SxqtLiE82shNIF1z3cgYRA 1348865218
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "\"will.deacon@arm.com, arm@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Tetsuyuki Kobayashi\"" <koba@kmckk.co.jp>,
        Tetsuyuki Kobayashi <koba@kmckk.co.jp>
Subject: [ 058/127] ARM: fix bad applied patch for arch/arm/Kconfig of stable 3.0.y tree.
Date: Fri, 28 Sep 2012 13:33:51 -0700
Message-Id: <20120928203052.616178747@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuyuki Kobayashi <koba@kmckk.co.jp>

No upstream commit as this is a merge error in the 3.0 tree.

ARM_ERRATA_764369 and PL310_ERRATA_769419 do not appear in config menu in
stable 3.0.y tree.
This is because backported patch for arm/arm/Kconfig applied wrong place.
This patch solves it.

Signed-off-by: Tetsuyuki Kobayashi <koba@kmckk.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig |   52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1234,6 +1234,32 @@ config ARM_ERRATA_754327
 	  This workaround defines cpu_relax() as smp_mb(), preventing correctly
 	  written polling loops from denying visibility of updates to memory.
 
+config ARM_ERRATA_764369
+	bool "ARM errata: Data cache line maintenance operation by MVA may not succeed"
+	depends on CPU_V7 && SMP
+	help
+	  This option enables the workaround for erratum 764369
+	  affecting Cortex-A9 MPCore with two or more processors (all
+	  current revisions). Under certain timing circumstances, a data
+	  cache line maintenance operation by MVA targeting an Inner
+	  Shareable memory region may fail to proceed up to either the
+	  Point of Coherency or to the Point of Unification of the
+	  system. This workaround adds a DSB instruction before the
+	  relevant cache maintenance functions and sets a specific bit
+	  in the diagnostic control register of the SCU.
+
+config PL310_ERRATA_769419
+	bool "PL310 errata: no automatic Store Buffer drain"
+	depends on CACHE_L2X0
+	help
+	  On revisions of the PL310 prior to r3p2, the Store Buffer does
+	  not automatically drain. This can cause normal, non-cacheable
+	  writes to be retained when the memory system is idle, leading
+	  to suboptimal I/O performance for drivers using coherent DMA.
+	  This option adds a write barrier to the cpu_idle loop so that,
+	  on systems with an outer cache, the store buffer is drained
+	  explicitly.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
@@ -1298,32 +1324,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
-config ARM_ERRATA_764369
-	bool "ARM errata: Data cache line maintenance operation by MVA may not succeed"
-	depends on CPU_V7 && SMP
-	help
-	  This option enables the workaround for erratum 764369
-	  affecting Cortex-A9 MPCore with two or more processors (all
-	  current revisions). Under certain timing circumstances, a data
-	  cache line maintenance operation by MVA targeting an Inner
-	  Shareable memory region may fail to proceed up to either the
-	  Point of Coherency or to the Point of Unification of the
-	  system. This workaround adds a DSB instruction before the
-	  relevant cache maintenance functions and sets a specific bit
-	  in the diagnostic control register of the SCU.
-
-config PL310_ERRATA_769419
-	bool "PL310 errata: no automatic Store Buffer drain"
-	depends on CACHE_L2X0
-	help
-	  On revisions of the PL310 prior to r3p2, the Store Buffer does
-	  not automatically drain. This can cause normal, non-cacheable
-	  writes to be retained when the memory system is idle, leading
-	  to suboptimal I/O performance for drivers using coherent DMA.
-	  This option adds a write barrier to the cpu_idle loop so that,
-	  on systems with an outer cache, the store buffer is drained
-	  explicitly.
-
 endmenu
 
 menu "Kernel Features"


