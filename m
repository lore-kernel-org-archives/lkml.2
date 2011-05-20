Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935764Ab1ETTNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691Ab1ETTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:38 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...,commit_signer:1/8=12%),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:6/8=75%),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Cliff Wickman <cpw@sgi.com> (commit_signer:3/8=38%),
        "Gustavo F. Padovan" <padovan@profusion.mobi> (commit_signer:1/8=12%),
        Jesper Juhl <jj@chaosbits.net> (commit_signer:1/8=12%)
Subject: [PATCH 4/8] x86: Kill set but not used warnings in tlb_uv.c
Date: Fri, 20 May 2011 16:13:01 -0300
Message-Id: <1305918786-7239-4-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 arch/x86/platform/uv/tlb_uv.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index c58e0ea..0f296e8 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -134,7 +134,6 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
 {
 	int i;
 	int cancel_count = 0;
-	int slot2;
 	unsigned long msg_res;
 	unsigned long mmr = 0;
 	struct bau_payload_queue_entry *msg;
@@ -159,7 +158,6 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
 			msg->sw_ack_vector) == 0) &&
 		    (msg2->sending_cpu == msg->sending_cpu) &&
 		    (msg2->msg_type != MSG_NOOP)) {
-			slot2 = msg2 - mdp->va_queue_first;
 			mmr = uv_read_local_mmr
 				(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
 			msg_res = msg2->sw_ack_vector;
@@ -278,7 +276,6 @@ static void
 uv_do_reset(void *ptr)
 {
 	int i;
-	int slot;
 	int count = 0;
 	unsigned long mmr;
 	unsigned long msg_res;
@@ -310,7 +307,6 @@ uv_do_reset(void *ptr)
 			 * make everyone else ignore this message
 			 */
 			msg->canceled = 1;
-			slot = msg - bcp->va_queue_first;
 			count++;
 			/*
 			 * only reset the resource if it is still pending
@@ -404,9 +400,6 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 	unsigned long descriptor_status;
 	cycles_t ttime;
 	struct ptc_stats *stat = bcp->statp;
-	struct bau_control *hmaster;
-
-	hmaster = bcp->uvhub_master;
 
 	/* spin on the status MMR, waiting for it to go idle */
 	while ((descriptor_status = (((unsigned long)
@@ -1409,14 +1402,12 @@ uv_payload_queue_init(int node, int pnode)
 	char *cp;
 	unsigned long pa;
 	struct bau_payload_queue_entry *pqp;
-	struct bau_payload_queue_entry *pqp_malloc;
 	struct bau_control *bcp;
 
 	pqp = kmalloc_node((DEST_Q_SIZE + 1)
 			   * sizeof(struct bau_payload_queue_entry),
 			   GFP_KERNEL, node);
 	BUG_ON(!pqp);
-	pqp_malloc = pqp;
 
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
-- 
1.7.5.1

