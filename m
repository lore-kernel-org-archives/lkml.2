Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1BVKve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:51:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1BVKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rZ+MTUbXRbvTps0rD5i7+TafjS6qXF86iFXJzLZTEu2XI/jovz8De6r3sl9tDABeep
         SAolTLMAiREyUCLiP3z2PQhwXdyhm+F86RupwOXOlp21l8bQA7m7saSt8R2YlR8g7g8m
         ectz0uXgiRJgekuVbHsWNEpiPYSGFWsxZ/9TQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [PATCH] mempolicy: remove redundant check in __mpol_equal()
Date: Tue, 22 Feb 2011 19:51:17 +0900
Message-Id: <1298371877-2906-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'flags' field is already checked, no need to do it again.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
---
 mm/mempolicy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 368fc9d23610..4244e4988e66 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1979,8 +1979,7 @@ int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 	case MPOL_INTERLEAVE:
 		return nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
-		return a->v.preferred_node == b->v.preferred_node &&
-			a->flags == b->flags;
+		return a->v.preferred_node == b->v.preferred_node;
 	default:
 		BUG();
 		return 0;
-- 
1.7.4

