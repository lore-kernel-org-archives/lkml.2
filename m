Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0I3DvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:51:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab0I3DvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dEynwhATIxb0eo1hm5JICCQspfOBbZDp3q7F73mdRQg5sK9guCwr2LOKWQDCCyIgYi
         JLPxQa5REQJ1zt6SukXPuMsBAX/9a0DSOxMSXzoZCKA3atKZ7tcqsm+/rrlRHRjanGpA
         3QHwDq/qy2tFzXY4FGmyhJVmq8VQSQNefY3Mw=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] vmstat: include compaction.h when CONFIG_COMPACTION
Date: Thu, 30 Sep 2010 12:50:21 +0900
Message-Id: <1285818621-29890-13-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes following warning from sparse:

 mm/vmstat.c:466:5: warning: symbol 'fragmentation_index' was not declared. Should it be static?

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/vmstat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 355a9e6..30054ea 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -394,6 +394,8 @@ void zone_statistics(struct zone *preferred_zone, struct zone *z)
 #endif
 
 #ifdef CONFIG_COMPACTION
+#include <linux/compaction.h>
+
 struct contig_page_info {
 	unsigned long free_pages;
 	unsigned long free_blocks_total;
-- 
1.7.2.2

