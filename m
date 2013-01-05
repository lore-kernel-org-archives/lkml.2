Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3AEFaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 00:30:21 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:45483 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3AEFaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 00:30:19 -0500
From: Joshua Zhu <zhu.wen-jie@hp.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org, dsahern@gmail.com,
        akihiro.nagai.hw@hitachi.com, jolsa@redhat.com, andi@firstfloor.org
Cc: zhu.wen-jie@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Perf: add anonymous huge page recognition
Date: Sat,  5 Jan 2013 13:29:57 +0800
Message-Id: <1357363797-3550-1-git-send-email-zhu.wen-jie@hp.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Judging anonymous memory's vm_area_struct,
perf_mmap_event's filename will be set to
"//anon" indicating this vma is belong to
anonymous memory.
Once hugepage is used, vma's vm_file points
to hugetlbfs. In this way, this vma will not
be regarded as anonymous memory by is_anon_memory()
in perf user space utility.

Signed-off-by: Joshua Zhu <zhu.wen-jie@hp.com>
---
 tools/perf/util/map.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 0328d45..ff94425 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -19,7 +19,8 @@ const char *map_type__name[MAP__NR_TYPES] = {
 
 static inline int is_anon_memory(const char *filename)
 {
-	return strcmp(filename, "//anon") == 0;
+	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
 static inline int is_no_dso_memory(const char *filename)
-- 
1.7.0.4

