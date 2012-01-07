Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2AGRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:25:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2AGRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:49 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] perf kmem: Fix a memory leak
Date: Sun,  8 Jan 2012 02:25:29 +0900
Message-Id: <1325957132-10600-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'str' should be freed when sort_dimension__add()
failed too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-kmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7a9b5c55ad5a..39104c0beea3 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -647,6 +647,7 @@ static int setup_sorting(struct list_head *sort_list, const char *arg)
 			break;
 		if (sort_dimension__add(tok, sort_list) < 0) {
 			error("Unknown --sort key: '%s'", tok);
+			free(str);
 			return -1;
 		}
 	}
-- 
1.7.6

