Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0FHDw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:52:56 -0400
Received: from mail.perches.com ([173.55.12.10]:2760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0FHDus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] arch/x86/kernel/tlb_uv.c: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:35 -0700
Message-Id: <3549b4f4015c1ffee1a7bed7288ce918e98c6697.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
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
1.7.1.244.gbdc4

