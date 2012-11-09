Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2KIVnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/21] perf hists: Free branch_info when freeing hist_entry
Date: Fri,  9 Nov 2012 18:42:52 -0300
Message-Id: <1352497390-17716-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those data should be free along with the associated hist_entry,
otherwise it'll be leaked.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352273234-28912-7-git-send-email-namhyung@kernel.org
[ committer note: mem_info is not yet in perf/core, free just branch_info ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 277947a..a1b823f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -410,6 +410,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 
 void hist_entry__free(struct hist_entry *he)
 {
+	free(he->branch_info);
 	free(he);
 }
 
-- 
1.7.9.2.358.g22243

