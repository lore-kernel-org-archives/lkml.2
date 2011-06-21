Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1FUMXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:23:17 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33411 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755901Ab1FUMWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:46 -0400
Message-Id: <20110621122242.230529678@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:27 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org, penberg@kernel.org
Subject: [patch 2/8 v5] x86, UV: inline header file functions
References: <20110621122125.688884227@sgi.com>
Content-Disposition: inline; filename=tlb_uv_inlineheaderfuncs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make all the functions in uv_bau.h inline so that it can
be included in the fake prom (used in simulations).

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---

If not inlined the unused functions will generate compiler warnings.

 arch/x86/include/asm/uv/uv_bau.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -526,72 +526,72 @@ struct bau_control {
 	struct hub_and_pnode	*thp;
 };
 
-static unsigned long read_mmr_uv2_status(void)
+static inline unsigned long read_mmr_uv2_status(void)
 {
 	return read_lmmr(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2);
 }
 
-static void write_mmr_data_broadcast(int pnode, unsigned long mmr_image)
+static inline void write_mmr_data_broadcast(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_BAU_DATA_BROADCAST, mmr_image);
 }
 
-static void write_mmr_descriptor_base(int pnode, unsigned long mmr_image)
+static inline void write_mmr_descriptor_base(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE, mmr_image);
 }
 
-static void write_mmr_activation(unsigned long index)
+static inline void write_mmr_activation(unsigned long index)
 {
 	write_lmmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
 }
 
-static void write_gmmr_activation(int pnode, unsigned long mmr_image)
+static inline void write_gmmr_activation(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_LB_BAU_SB_ACTIVATION_CONTROL, mmr_image);
 }
 
-static void write_mmr_payload_first(int pnode, unsigned long mmr_image)
+static inline void write_mmr_payload_first(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST, mmr_image);
 }
 
-static void write_mmr_payload_tail(int pnode, unsigned long mmr_image)
+static inline void write_mmr_payload_tail(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL, mmr_image);
 }
 
-static void write_mmr_payload_last(int pnode, unsigned long mmr_image)
+static inline void write_mmr_payload_last(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST, mmr_image);
 }
 
-static void write_mmr_misc_control(int pnode, unsigned long mmr_image)
+static inline void write_mmr_misc_control(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 }
 
-static unsigned long read_mmr_misc_control(int pnode)
+static inline unsigned long read_mmr_misc_control(int pnode)
 {
 	return read_gmmr(pnode, UVH_LB_BAU_MISC_CONTROL);
 }
 
-static void write_mmr_sw_ack(unsigned long mr)
+static inline void write_mmr_sw_ack(unsigned long mr)
 {
 	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, mr);
 }
 
-static unsigned long read_mmr_sw_ack(void)
+static inline unsigned long read_mmr_sw_ack(void)
 {
 	return read_lmmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
 }
 
-static unsigned long read_gmmr_sw_ack(int pnode)
+static inline unsigned long read_gmmr_sw_ack(int pnode)
 {
 	return read_gmmr(pnode, UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
 }
 
-static void write_mmr_data_config(int pnode, unsigned long mr)
+static inline void write_mmr_data_config(int pnode, unsigned long mr)
 {
 	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG, mr);
 }

