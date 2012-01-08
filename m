Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2AHPmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:42:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:59592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab2AHPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf kmem: Fix a memory leak
Date: Sun,  8 Jan 2012 13:42:15 -0200
Message-Id: <1326037339-31125-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The 'str' should be freed when sort_dimension__add() failed too.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-5-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7a9b5c5..39104c0 100644
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
1.7.8.GIT

