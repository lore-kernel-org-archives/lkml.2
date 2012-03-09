Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030883Ab2CIUjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:39:48 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51845 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030324Ab2CIUjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:39:40 -0500
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: cgroups@vger.kernel.org
Cc: suleiman@google.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com,
        penberg@kernel.org, cl@linux.com, yinghan@google.com, hughd@google.com,
        gthelen@google.com, peterz@infradead.org, dan.magenheimer@oracle.com,
        hannes@cmpxchg.org, mgorman@suse.de,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <ssouhlal@FreeBSD.org>
Subject: [PATCH v2 08/13] memcg: Make dentry slab memory accounted in kernel memory accounting.
Date: Fri,  9 Mar 2012 12:39:11 -0800
Message-Id: <1331325556-16447-9-git-send-email-ssouhlal@FreeBSD.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: <suleiman@google.com>
---
 fs/dcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index bcbdb33..cc6dd92 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3022,8 +3022,8 @@ static void __init dcache_init(void)
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache. 
 	 */
-	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+	dentry_cache = KMEM_CACHE(dentry, SLAB_RECLAIM_ACCOUNT | SLAB_PANIC |
+	    SLAB_MEM_SPREAD | SLAB_MEMCG_ACCT);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
-- 
1.7.7.3

