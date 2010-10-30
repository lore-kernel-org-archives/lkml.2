Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0J3Vx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:53:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12052 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0J3VxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:53:23 -0400
Date: Sat, 30 Oct 2010 23:43:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] kmemleak: remove memset by using kzalloc
Message-ID: <alpine.LNX.2.00.1010302340260.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to memset if we just use kzalloc() rather than kmalloc() in 
kmemleak_test_init().

(please CC on replies)


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kmemleak-test.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak-test.c b/mm/kmemleak-test.c
index 177a516..ff0d977 100644
--- a/mm/kmemleak-test.c
+++ b/mm/kmemleak-test.c
@@ -75,13 +75,11 @@ static int __init kmemleak_test_init(void)
 	 * after the module is removed.
 	 */
 	for (i = 0; i < 10; i++) {
-		elem = kmalloc(sizeof(*elem), GFP_KERNEL);
-		pr_info("kmemleak: kmalloc(sizeof(*elem)) = %p\n", elem);
+		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
+		pr_info("kmemleak: kzalloc(sizeof(*elem)) = %p\n", elem);
 		if (!elem)
 			return -ENOMEM;
-		memset(elem, 0, sizeof(*elem));
 		INIT_LIST_HEAD(&elem->list);
-
 		list_add_tail(&elem->list, &test_list);
 	}
 


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

