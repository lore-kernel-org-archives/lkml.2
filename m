Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab2KATD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:03:28 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:40412 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab2KATD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:03:27 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] scatterlist: don't BUG when we can trivially return a proper error.
Date: Thu,  1 Nov 2012 15:03:00 -0400
Message-Id: <1351796580-20600-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is absolutely no reason to crash the kernel when we have a
perfectly good return value already available to use for conveying
failure status.

Let's return an error code instead of crashing the kernel: that sounds
like a much better plan.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 lib/scatterlist.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 3675452b23ca..11ecaf000696 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -248,7 +248,8 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 	unsigned int left;
 
 #ifndef ARCH_HAS_SG_CHAIN
-	BUG_ON(nents > max_ents);
+	if (WARN_ON_ONCE(nents > max_ents))
+		return -E2BIG;
 #endif
 
 	memset(table, 0, sizeof(*table));
-- 
1.7.8.6

