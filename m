Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1AVAHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:07:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42731 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1AVAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fxyURtE73vBU95IuX2i0+bEtEe+Rn5cUHr5crzqCte1bQNNk6H0Z+dKGaRxhv2QQFJ
         gfZk82e1xacYwJ1Kkxj31wA9iBChvCQULSXwk1DcBFAuYdLeNomf2jGUs5owyM1Gi6MK
         ttRh2mjVJSwZIj2hB20xJBnx6G2+Ydd7wJX3Y=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] migration: clear migrate_pages's comment
Date: Sat, 22 Jan 2011 09:06:52 +0900
Message-Id: <1295654812-2108-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of migrate_pages should putback_lru_pages to return pages
isolated to LRU or free list. Now comment is rather confusing.
It says caller always have to call it.
More clear thing is that caller have to call it if migrate_pages's 
return value isn't zero.

Cc: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3a6d4fd..7661152 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -887,7 +887,7 @@ out:
  * are movable anymore because to has become empty
  * or no retryable pages exist anymore.
  * Caller should call putback_lru_pages to return pages to the LRU
- * or free list.
+ * or free list only if ret != 0.
  *
  * Return: Number of pages not migrated or error code.
  */
-- 
1.7.0.4

