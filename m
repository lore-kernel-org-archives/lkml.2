Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2G3TsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:48:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44933 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab2G3TsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:48:08 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, trivial@kernel.org
Subject: [PATCH][TRIVIAL] mm/frontswap: fix uninit'ed variable warning
Date: Mon, 30 Jul 2012 14:47:44 -0500
Message-Id: <1343677664-26665-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073019-9360-0000-0000-000008EB6FE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes uninitialized variable warning on 'type' in frontswap_shrink().
type is set before use by __frontswap_unuse_pages() called by
__frontswap_shrink() called by frontswap_shrink() before use by
try_to_unuse().

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
Based on next-20120730

 mm/frontswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 6b3e71a..89dc399 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -292,7 +292,7 @@ static int __frontswap_shrink(unsigned long target_pages,
 void frontswap_shrink(unsigned long target_pages)
 {
 	unsigned long pages_to_unuse = 0;
-	int type, ret;
+	int uninitialized_var(type), ret;
 
 	/*
 	 * we don't want to hold swap_lock while doing a very
-- 
1.7.9.5

