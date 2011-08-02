Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1HBKhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:37:02 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59129 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1HBKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:17 -0400
From: Julia Lawall <julia@diku.dk>
To: Chris Metcalf <cmetcalf@tilera.com>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] arch/tile/mm/init.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:35:04 +0200
Message-Id: <1312281304-11847-12-git-send-email-julia@diku.dk>
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
 arch/tile/mm/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/tile/mm/init.c b/arch/tile/mm/init.c
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -836,8 +836,7 @@ void __init mem_init(void)
 #endif
 
 #ifdef CONFIG_FLATMEM
-	if (!mem_map)
-		BUG();
+	BUG_ON(!mem_map);
 #endif
 
 #ifdef CONFIG_HIGHMEM

