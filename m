Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1FNXFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 19:05:31 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39474 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1FNXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 19:05:29 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2 of 6] x86, UV: inline header file functions
Cc: mingo@elte.hu
Message-Id: <E1QWcgv-0004N2-Jj@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 14 Jun 2011 18:06:37 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Make all the functions in uv_bau.h inline so that it can
be included in the fake prom (used in simulations).
Otherwise they will generate warnings for unused functions.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
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
