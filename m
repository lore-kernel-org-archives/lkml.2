Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab2IUTPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:15:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51904 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2IUTPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:15:34 -0400
Date: Fri, 21 Sep 2012 21:15:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120921191529.GA24617@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 73e8f3d7e2cb23614d5115703d76d8e54764b641 x86/mm/init.c: Fix devmem_is_allowed() off by one

Small fixlets.

 Thanks,

	Ingo

------------------>
Joe Millenbach (1):
      x86/kconfig: Remove outdated reference to Intel CPUs in CONFIG_SWIOTLB

T Makphaibulchoke (1):
      x86/mm/init.c: Fix devmem_is_allowed() off by one


 arch/x86/Kconfig   | 8 ++++----
 arch/x86/mm/init.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..50a1d1f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -746,10 +746,10 @@ config SWIOTLB
 	def_bool y if X86_64
 	---help---
 	  Support for software bounce buffers used on x86-64 systems
-	  which don't have a hardware IOMMU (e.g. the current generation
-	  of Intel's x86-64 CPUs). Using this PCI devices which can only
-	  access 32-bits of memory can be used on systems with more than
-	  3 GB of memory. If unsure, say Y.
+	  which don't have a hardware IOMMU. Using this PCI devices
+	  which can only access 32-bits of memory can be used on systems
+	  with more than 3 GB of memory.
+	  If unsure, say Y.
 
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..ab1f6a9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -319,7 +319,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  */
 int devmem_is_allowed(unsigned long pagenr)
 {
-	if (pagenr <= 256)
+	if (pagenr < 256)
 		return 1;
 	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
 		return 0;
