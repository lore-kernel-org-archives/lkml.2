Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1HBKfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:35:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59056 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1HBKfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:11 -0400
From: Julia Lawall <julia@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        Andrea Righi <arighi@develer.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/11] kernel/kfifo.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:54 +0200
Message-Id: <1312281304-11847-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 kernel/kfifo.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -u -p a/kernel/kfifo.c b/kernel/kfifo.c
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -562,8 +562,7 @@ EXPORT_SYMBOL(__kfifo_to_user_r);
 unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
+	BUG_ON(!nents);
 
 	len = __kfifo_max_r(len, recsize);
 
@@ -586,8 +585,7 @@ EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
 unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
+	BUG_ON(!nents);
 
 	len = __kfifo_max_r(len, recsize);
 

