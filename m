Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0FAD1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:27:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2466 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0FADXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:25 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/21] arch/x86/kernel/tlb_uv.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:05 -0700
Message-Id: <420ba927cc1d2fa969c2e31c0a01814af767310e.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And convert a kmalloc/memset to kzalloc

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/tlb_uv.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 7fea555..4c0a5e8 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1141,8 +1141,9 @@ uv_activation_descriptor_init(int node, int pnode)
 	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
 	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per uvhub
 	 */
-	bau_desc = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
-		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
+	bau_desc = kmalloc_node(sizeof(struct bau_desc) *
+				UV_ADP_SIZE * UV_ITEMS_PER_DESCRIPTOR,
+				GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
 	pa = uv_gpa(bau_desc); /* need the real nasid*/
@@ -1200,9 +1201,9 @@ uv_payload_queue_init(int node, int pnode)
 	struct bau_payload_queue_entry *pqp_malloc;
 	struct bau_control *bcp;
 
-	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
-		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
-		GFP_KERNEL, node);
+	pqp = kmalloc_node((DEST_Q_SIZE + 1) *
+			   sizeof(struct bau_payload_queue_entry),
+			   GFP_KERNEL, node);
 	BUG_ON(!pqp);
 	pqp_malloc = pqp;
 
@@ -1286,9 +1287,7 @@ static void uv_init_per_cpu(int nuvhubs)
 	};
 	struct uvhub_desc *uvhub_descs;
 
-	uvhub_descs = (struct uvhub_desc *)
-		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_descs = kzalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
-- 
1.7.0.3.311.g6a6955

