Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0KFUlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 16:41:08 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56453 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab0KFUlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 16:41:07 -0400
Date: Sat, 6 Nov 2010 15:41:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Update node controller MMRs
Message-ID: <20101106204056.GA27584@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new version of the SGI UV hub node controller is being developed. A few of the
MMRs (control registers) that exist on the current hub no longer
exist on the new hub. Fortunately, there are alternate MMRs that are
are functionally equivalent and that exist on both hubs.

This patch changes the UV code to use MMRs that exist in BOTH versions
of the hub node controller.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_mmrs.h  |  189 ++++++++++++++++++-------------------
 arch/x86/kernel/apic/x2apic_uv_x.c |   12 +-
 2 files changed, 102 insertions(+), 99 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2010-11-06 15:25:25.491168545 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2010-11-06 15:25:56.444650395 -0500
@@ -806,6 +806,78 @@ union uvh_node_present_table_u {
 };
 
 /* ========================================================================= */
+/*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR 0x16000c8UL
+
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_BASE_MASK 0x00000000ff000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_M_ALIAS_SHFT 48
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_alias210_overlay_config_0_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_overlay_config_0_mmr_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR 0x16000d8UL
+
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_BASE_MASK 0x00000000ff000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_M_ALIAS_SHFT 48
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_alias210_overlay_config_1_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_overlay_config_1_mmr_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR 0x16000e8UL
+
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_BASE_MASK 0x00000000ff000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_M_ALIAS_SHFT 48
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_alias210_overlay_config_2_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_overlay_config_2_mmr_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
 /*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR                  */
 /* ========================================================================= */
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR 0x16000d0UL
@@ -857,6 +929,29 @@ union uvh_rh_gam_alias210_redirect_confi
 };
 
 /* ========================================================================= */
+/*                          UVH_RH_GAM_CONFIG_MMR                            */
+/* ========================================================================= */
+#define UVH_RH_GAM_CONFIG_MMR 0x1600000UL
+
+#define UVH_RH_GAM_CONFIG_MMR_M_SKT_SHFT 0
+#define UVH_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
+#define UVH_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
+#define UVH_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
+#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_SHFT 12
+#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK 0x0000000000001000UL
+
+union uvh_rh_gam_config_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_config_mmr_s {
+	unsigned long	m_skt     :  6;  /* RW */
+	unsigned long	n_skt     :  4;  /* RW */
+	unsigned long	rsvd_10_11:  2;  /*    */
+	unsigned long	mmiol_cfg :  1;  /* RW */
+	unsigned long	rsvd_13_63: 51;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                    UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
@@ -987,97 +1082,5 @@ union uvh_rtc1_int_config_u {
     } s;
 };
 
-/* ========================================================================= */
-/*                          UVH_SI_ADDR_MAP_CONFIG                           */
-/* ========================================================================= */
-#define UVH_SI_ADDR_MAP_CONFIG 0xc80000UL
-
-#define UVH_SI_ADDR_MAP_CONFIG_M_SKT_SHFT 0
-#define UVH_SI_ADDR_MAP_CONFIG_M_SKT_MASK 0x000000000000003fUL
-#define UVH_SI_ADDR_MAP_CONFIG_N_SKT_SHFT 8
-#define UVH_SI_ADDR_MAP_CONFIG_N_SKT_MASK 0x0000000000000f00UL
-
-union uvh_si_addr_map_config_u {
-    unsigned long	v;
-    struct uvh_si_addr_map_config_s {
-	unsigned long	m_skt :  6;  /* RW */
-	unsigned long	rsvd_6_7:  2;  /*    */
-	unsigned long	n_skt :  4;  /* RW */
-	unsigned long	rsvd_12_63: 52;  /*    */
-    } s;
-};
-
-/* ========================================================================= */
-/*                       UVH_SI_ALIAS0_OVERLAY_CONFIG                        */
-/* ========================================================================= */
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG 0xc80008UL
-
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_BASE_SHFT 24
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_M_ALIAS_SHFT 48
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_ENABLE_SHFT 63
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_si_alias0_overlay_config_u {
-    unsigned long	v;
-    struct uvh_si_alias0_overlay_config_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                       UVH_SI_ALIAS1_OVERLAY_CONFIG                        */
-/* ========================================================================= */
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG 0xc80010UL
-
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_BASE_SHFT 24
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_M_ALIAS_SHFT 48
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_ENABLE_SHFT 63
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_si_alias1_overlay_config_u {
-    unsigned long	v;
-    struct uvh_si_alias1_overlay_config_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                       UVH_SI_ALIAS2_OVERLAY_CONFIG                        */
-/* ========================================================================= */
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG 0xc80018UL
-
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_BASE_SHFT 24
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_M_ALIAS_SHFT 48
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_ENABLE_SHFT 63
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_si_alias2_overlay_config_u {
-    unsigned long	v;
-    struct uvh_si_alias2_overlay_config_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
-};
-
 
-#endif /* _ASM_X86_UV_UV_MMRS_H */
+#endif /* __ASM_UV_MMRS_X86_H__ */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-11-06 15:25:26.255033100 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-11-06 15:25:56.456737534 -0500
@@ -379,14 +379,14 @@ struct redir_addr {
 #define DEST_SHIFT UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_SHFT
 
 static __initdata struct redir_addr redir_addrs[] = {
-	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR, UVH_SI_ALIAS0_OVERLAY_CONFIG},
-	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR, UVH_SI_ALIAS1_OVERLAY_CONFIG},
-	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR, UVH_SI_ALIAS2_OVERLAY_CONFIG},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR},
 };
 
 static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 {
-	union uvh_si_alias0_overlay_config_u alias;
+	union uvh_rh_gam_alias210_overlay_config_2_mmr_u alias;
 	union uvh_rh_gam_alias210_redirect_config_2_mmr_u redirect;
 	int i;
 
@@ -660,7 +660,7 @@ void uv_nmi_init(void)
 
 void __init uv_system_init(void)
 {
-	union uvh_si_addr_map_config_u m_n_config;
+	union uvh_rh_gam_config_mmr_u  m_n_config;
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
@@ -670,7 +670,7 @@ void __init uv_system_init(void)
 
 	map_low_mmrs();
 
-	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
+	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
 	mmr_base =
