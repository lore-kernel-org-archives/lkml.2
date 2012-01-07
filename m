Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2AGR1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:27:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2AGRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:46 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] perf kmem: Add missing closedir() calls
Date: Sun,  8 Jan 2012 02:25:28 +0900
Message-Id: <1325957132-10600-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The setup_cpunode_map() calls opendir() but misses corresponding
closedir(). Add them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-kmem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fe1ad8f21961..7a9b5c55ad5a 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -108,7 +108,9 @@ static void setup_cpunode_map(void)
 				continue;
 			cpunode_map[cpu] = mem;
 		}
+		closedir(dir2);
 	}
+	closedir(dir1);
 }
 
 static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
-- 
1.7.6

