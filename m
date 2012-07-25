Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab2GYIHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:07:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:48282 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458Ab2GYIG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:06:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126645753"
Date: Wed, 25 Jul 2012 16:06:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, alsa-devel@alsa-project.org
Subject: [PATCH] ia64: rename platform_name to ia64_platform_name
Message-ID: <20120725080653.GA18233@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro name is too generic and conflicts with
snd_soc_dai_link.platform_name, which triggers lots of ALSA build errors.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

(not sure if the previous sent was successful, so resend)

 arch/ia64/include/asm/machvec.h               |    2 +-
 arch/ia64/include/asm/machvec_dig.h           |    2 +-
 arch/ia64/include/asm/machvec_dig_vtd.h       |    2 +-
 arch/ia64/include/asm/machvec_hpsim.h         |    2 +-
 arch/ia64/include/asm/machvec_hpzx1.h         |    2 +-
 arch/ia64/include/asm/machvec_hpzx1_swiotlb.h |    2 +-
 arch/ia64/include/asm/machvec_sn2.h           |    2 +-
 arch/ia64/include/asm/machvec_uv.h            |    2 +-
 arch/ia64/include/asm/machvec_xen.h           |    2 +-
 arch/ia64/include/asm/processor.h             |    2 +-
 arch/ia64/pci/fixup.c                         |    4 ++--
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 367d299..2d1ad4b1 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -120,7 +120,7 @@ extern void machvec_tlb_migrate_finish (struct mm_struct *);
 # ifdef MACHVEC_PLATFORM_HEADER
 #  include MACHVEC_PLATFORM_HEADER
 # else
-#  define platform_name		ia64_mv.name
+#  define ia64_platform_name	ia64_mv.name
 #  define platform_setup	ia64_mv.setup
 #  define platform_cpu_init	ia64_mv.cpu_init
 #  define platform_irq_init	ia64_mv.irq_init
diff --git a/arch/ia64/include/asm/machvec_dig.h b/arch/ia64/include/asm/machvec_dig.h
index 8a0752f..1f7403a 100644
--- a/arch/ia64/include/asm/machvec_dig.h
+++ b/arch/ia64/include/asm/machvec_dig.h
@@ -10,7 +10,7 @@ extern ia64_mv_setup_t dig_setup;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name		"dig"
+#define ia64_platform_name	"dig"
 #define platform_setup		dig_setup
 
 #endif /* _ASM_IA64_MACHVEC_DIG_h */
diff --git a/arch/ia64/include/asm/machvec_dig_vtd.h b/arch/ia64/include/asm/machvec_dig_vtd.h
index 6ab1de5..44308b4 100644
--- a/arch/ia64/include/asm/machvec_dig_vtd.h
+++ b/arch/ia64/include/asm/machvec_dig_vtd.h
@@ -11,7 +11,7 @@ extern ia64_mv_dma_init			pci_iommu_alloc;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name				"dig_vtd"
+#define ia64_platform_name			"dig_vtd"
 #define platform_setup				dig_setup
 #define platform_dma_init			pci_iommu_alloc
 
diff --git a/arch/ia64/include/asm/machvec_hpsim.h b/arch/ia64/include/asm/machvec_hpsim.h
index cf72fc8..e757112 100644
--- a/arch/ia64/include/asm/machvec_hpsim.h
+++ b/arch/ia64/include/asm/machvec_hpsim.h
@@ -11,7 +11,7 @@ extern ia64_mv_irq_init_t hpsim_irq_init;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name		"hpsim"
+#define ia64_platform_name	"hpsim"
 #define platform_setup		hpsim_setup
 #define platform_irq_init	hpsim_irq_init
 
diff --git a/arch/ia64/include/asm/machvec_hpzx1.h b/arch/ia64/include/asm/machvec_hpzx1.h
index 3bd83d7..c74d315 100644
--- a/arch/ia64/include/asm/machvec_hpzx1.h
+++ b/arch/ia64/include/asm/machvec_hpzx1.h
@@ -11,7 +11,7 @@ extern ia64_mv_dma_init			sba_dma_init;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name				"hpzx1"
+#define ia64_platform_name			"hpzx1"
 #define platform_setup				dig_setup
 #define platform_dma_init			sba_dma_init
 
diff --git a/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h b/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
index 1091ac3..906ef62 100644
--- a/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
+++ b/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
@@ -11,7 +11,7 @@ extern ia64_mv_dma_get_ops			hwsw_dma_get_ops;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name				"hpzx1_swiotlb"
+#define ia64_platform_name			"hpzx1_swiotlb"
 #define platform_setup				dig_setup
 #define platform_dma_init			machvec_noop
 #define platform_dma_get_ops			hwsw_dma_get_ops
diff --git a/arch/ia64/include/asm/machvec_sn2.h b/arch/ia64/include/asm/machvec_sn2.h
index f061a30..ece9fa8 100644
--- a/arch/ia64/include/asm/machvec_sn2.h
+++ b/arch/ia64/include/asm/machvec_sn2.h
@@ -71,7 +71,7 @@ extern ia64_mv_pci_fixup_bus_t		sn_pci_fixup_bus;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name			"sn2"
+#define ia64_platform_name		"sn2"
 #define platform_setup			sn_setup
 #define platform_cpu_init		sn_cpu_init
 #define platform_irq_init		sn_irq_init
diff --git a/arch/ia64/include/asm/machvec_uv.h b/arch/ia64/include/asm/machvec_uv.h
index 2931447..2c50853 100644
--- a/arch/ia64/include/asm/machvec_uv.h
+++ b/arch/ia64/include/asm/machvec_uv.h
@@ -20,7 +20,7 @@ extern ia64_mv_setup_t uv_setup;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name			"uv"
+#define ia64_platform_name		"uv"
 #define platform_setup			uv_setup
 
 #endif /* _ASM_IA64_MACHVEC_UV_H */
diff --git a/arch/ia64/include/asm/machvec_xen.h b/arch/ia64/include/asm/machvec_xen.h
index 55f9228..8b8bd0e 100644
--- a/arch/ia64/include/asm/machvec_xen.h
+++ b/arch/ia64/include/asm/machvec_xen.h
@@ -13,7 +13,7 @@ extern ia64_mv_send_ipi_t		xen_platform_send_ipi;
  * platform's machvec structure.  When compiling a non-generic kernel,
  * the macros are used directly.
  */
-#define platform_name				"xen"
+#define ia64_platform_name			"xen"
 #define platform_setup				dig_setup
 #define platform_cpu_init			xen_cpu_init
 #define platform_irq_init			xen_irq_init
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 832dd37..944152a 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -719,7 +719,7 @@ enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
 
 void default_idle(void);
 
-#define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
+#define ia64_platform_is(x) (strcmp(x, ia64_platform_name) == 0)
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/ia64/pci/fixup.c b/arch/ia64/pci/fixup.c
index f5959c0..eab28e3 100644
--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -30,8 +30,8 @@ static void __devinit pci_fixup_video(struct pci_dev *pdev)
 	struct pci_bus *bus;
 	u16 config;
 
-	if ((strcmp(platform_name, "dig") != 0)
-	    && (strcmp(platform_name, "hpzx1")  != 0))
+	if ((strcmp(ia64_platform_name, "dig") != 0)
+	    && (strcmp(ia64_platform_name, "hpzx1")  != 0))
 		return;
 	/* Maybe, this machine supports legacy memory map. */
 
-- 
1.7.10

