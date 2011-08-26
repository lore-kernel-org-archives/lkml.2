Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1HZQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:28:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59326 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1HZQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:28:07 -0400
From: Zhao Jin <cronozhj@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, Zhao Jin <cronozhj@gmail.com>
Subject: [PATCH 1/2][RESEND] slab, cleanup: remove unneeded return
Date: Sat, 27 Aug 2011 00:26:17 +0800
Message-Id: <1314375977-14927-1-git-send-email-cronozhj@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The procedure ends right after the if-statement, so remove ``return''.
Also move the last common statement outside.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 mm/slab.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 6d90a09..82e0a0e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3678,13 +3678,12 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 
 	if (likely(ac->avail < ac->limit)) {
 		STATS_INC_FREEHIT(cachep);
-		ac->entry[ac->avail++] = objp;
-		return;
 	} else {
 		STATS_INC_FREEMISS(cachep);
 		cache_flusharray(cachep, ac);
-		ac->entry[ac->avail++] = objp;
 	}
+
+	ac->entry[ac->avail++] = objp;
 }
 
 /**
-- 
1.7.4.1

