Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0FHDwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:52:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2767 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0FHDut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:49 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] drivers/parisc/iosapic.c: Remove unnecessary kzalloc cast
Date: Mon,  7 Jun 2010 20:50:40 -0700
Message-Id: <faeb41be5101e49ed46ce24985a4a98ad39eeef1.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert kzalloc to kcalloc

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parisc/iosapic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index c768367..3e6f56c 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -891,8 +891,8 @@ void *iosapic_register(unsigned long hpa)
 	isi->isi_version = iosapic_rd_version(isi);
 	isi->isi_num_vectors = IOSAPIC_IRDT_MAX_ENTRY(isi->isi_version) + 1;
 
-	vip = isi->isi_vector = (struct vector_info *)
-		kzalloc(sizeof(struct vector_info) * isi->isi_num_vectors, GFP_KERNEL);
+	vip = isi->isi_vector = kcalloc(isi->isi_num_vectors,
+					sizeof(struct vector_info), GFP_KERNEL);
 	if (vip == NULL) {
 		kfree(isi);
 		return NULL;
-- 
1.7.1.244.gbdc4

