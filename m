Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1FUPRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:17:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:59954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1FUPRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:17:01 -0400
Date: Tue, 21 Jun 2011 15:16:42 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-b18fb2c04ac46885f5b0226cd945e763eae51567@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.230529678@sgi.com>
References: <20110621122242.230529678@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Inline header file functions
Git-Commit-ID: b18fb2c04ac46885f5b0226cd945e763eae51567
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:16:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b18fb2c04ac46885f5b0226cd945e763eae51567
Gitweb:     http://git.kernel.org/tip/b18fb2c04ac46885f5b0226cd945e763eae51567
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:27 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:31 +0200

x86, UV: Inline header file functions

Make all the functions in uv_bau.h inline so that it can
be included in the fake prom (used in simulations).

If not inlined the unused functions will generate compiler warnings.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/20110621122242.230529678@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index a291c40..605e613 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
