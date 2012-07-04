Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2GDA4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 20:56:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48505 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab2GDA4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 20:56:05 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-b0-4ff394a28505
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] mm: fix vmstat and zonestat mismatch
Date: Wed,  4 Jul 2012 09:56:41 +0900
Message-Id: <1341363401-19326-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e975d6ac[1] in linux-next removed NUMA_INTERLEAVE_HIT
in zone_stat_item but didn't remove it in vmstat_text
so that cat /proc/vmstat doesn't show right count number.

[1]: mm/mpol: Remove NUMA_INTERLEAVE_HIT

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmstat.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1bbbbd9..e4db312 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -717,7 +717,6 @@ const char * const vmstat_text[] = {
 	"numa_hit",
 	"numa_miss",
 	"numa_foreign",
-	"numa_interleave",
 	"numa_local",
 	"numa_other",
 #endif
-- 
1.7.9.5

