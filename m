Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1LTTTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:19:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:33871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1LTTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf symbols: Fix error path on symbol__init()
Date: Tue, 20 Dec 2011 17:18:07 -0200
Message-Id: <1324408691-28296-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The order of freeing comm_list and dso_list should be reversed.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-4-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e54b13d..215d50f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2604,10 +2604,10 @@ int symbol__init(void)
 	symbol_conf.initialized = true;
 	return 0;
 
-out_free_dso_list:
-	strlist__delete(symbol_conf.dso_list);
 out_free_comm_list:
 	strlist__delete(symbol_conf.comm_list);
+out_free_dso_list:
+	strlist__delete(symbol_conf.dso_list);
 	return -1;
 }
 
-- 
1.7.8.rc0.35.gee6df

