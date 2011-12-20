Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1LTTSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:18:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50589 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1LTTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/10] perf tools: Fix a memory leak on perf_read_values_destroy
Date: Tue, 20 Dec 2011 17:18:08 -0200
Message-Id: <1324408691-28296-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

After freeing each elements of the @values->value, we should free itself
too.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-5-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/values.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index bdd3347..697c8b4e 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -32,6 +32,7 @@ void perf_read_values_destroy(struct perf_read_values *values)
 
 	for (i = 0; i < values->threads; i++)
 		free(values->value[i]);
+	free(values->value);
 	free(values->pid);
 	free(values->tid);
 	free(values->counterrawid);
-- 
1.7.8.rc0.35.gee6df

