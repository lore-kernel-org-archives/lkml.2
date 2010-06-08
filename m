Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0FHDxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:53:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2759 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0FHDur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:47 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] arch/powerpc: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:34 -0700
Message-Id: <96933b66aa5f995746a34410ca63e5e8b84593cb.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kernel/nvram_64.c |    3 +--
 arch/powerpc/kvm/book3s.c      |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index 9cf197f..99c6dab 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -502,8 +502,7 @@ static int __init nvram_scan_partitions(void)
 			       "detected: 0-length partition\n");
 			goto out;
 		}
-		tmp_part = (struct nvram_partition *)
-			kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
+		tmp_part = kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
 		err = -ENOMEM;
 		if (!tmp_part) {
 			printk(KERN_ERR "nvram_scan_partitions: kmalloc failed\n");
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index b998abf..2a8b9b6 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1248,8 +1248,8 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
 
 	memset(vcpu_book3s, 0, sizeof(struct kvmppc_vcpu_book3s));
 
-	vcpu_book3s->shadow_vcpu = (struct kvmppc_book3s_shadow_vcpu *)
-		kzalloc(sizeof(*vcpu_book3s->shadow_vcpu), GFP_KERNEL);
+	vcpu_book3s->shadow_vcpu = kzalloc(sizeof(*vcpu_book3s->shadow_vcpu),
+					   GFP_KERNEL);
 	if (!vcpu_book3s->shadow_vcpu)
 		goto free_vcpu;
 
-- 
1.7.1.244.gbdc4

