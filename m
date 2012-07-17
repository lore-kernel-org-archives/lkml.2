Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2GQWkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:40:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39617 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab2GQWj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:39:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 05/17] n2_crypto: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:24 -0400
Message-Id: <1342560756-18737-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/n2_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 67b97c5..a8bd031 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1610,8 +1610,7 @@ static int spu_map_ino(struct platform_device *dev, struct spu_mdesc_info *ip,
 
 	sprintf(p->irq_name, "%s-%d", irq_name, index);
 
-	return request_irq(p->irq, handler, IRQF_SAMPLE_RANDOM,
-			   p->irq_name, p);
+	return request_irq(p->irq, handler, 0, p->irq_name, p);
 }
 
 static struct kmem_cache *queue_cache[2];
-- 
1.7.11.1.108.gb129051

