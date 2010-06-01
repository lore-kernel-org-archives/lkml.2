Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0FADXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:35 -0400
Received: from mail.perches.com ([173.55.12.10]:2473 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0FADXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:32 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 14/21] drivers/parisc/iosapic.c: Remove unnecessary kzalloc cast
Date: Mon, 31 May 2010 20:23:16 -0700
Message-Id: <ba7d48df75ca37c39b0e519921c116a617e71db7.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
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
1.7.0.3.311.g6a6955

