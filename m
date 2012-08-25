Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2HYOMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 10:12:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41116 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2HYOMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 10:12:31 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 2/2] slab: fix starting index for finding another object
Date: Sat, 25 Aug 2012 23:11:11 +0900
Message-Id: <1345903871-1921-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345903871-1921-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1345903871-1921-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In array cache, there is a object at index 0.
So fix it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>

diff --git a/mm/slab.c b/mm/slab.c
index 45cf59a..eb74bf5 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -976,7 +976,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		}
 
 		/* The caller cannot use PFMEMALLOC objects, find another one */
-		for (i = 1; i < ac->avail; i++) {
+		for (i = 0; i < ac->avail; i++) {
 			/* If a !PFMEMALLOC object is found, swap them */
 			if (!is_obj_pfmemalloc(ac->entry[i])) {
 				objp = ac->entry[i];
-- 
1.7.9.5

