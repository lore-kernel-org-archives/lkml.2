Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2I0O3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:29:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54402 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2I0O26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:28:58 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH] scatterlist: refactor the sg_nents
Date: Thu, 27 Sep 2012 16:28:37 +0200
Message-Id: <1348756117-5299-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <50642ECB.20707@kernel.dk>
References: <50642ECB.20707@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace 'while' with 'for' as suggested by Tejun Heo

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 lib/scatterlist.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 5cd9cdc..3675452b 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -49,12 +49,9 @@ EXPORT_SYMBOL(sg_next);
  **/
 int sg_nents(struct scatterlist *sg)
 {
-	int nents = 0;
-	while (sg) {
+	int nents;
+	for (nents = 0; sg; sg = sg_next(sg))
 		nents++;
-		sg = sg_next(sg);
-	}
-
 	return nents;
 }
 EXPORT_SYMBOL(sg_nents);
-- 
1.7.9.5

