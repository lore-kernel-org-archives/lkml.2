Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2LKWu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:50:28 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53868
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755262Ab2LKWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/37] perf symbols: Fix dso__fprintf() print statement
Date: Tue, 11 Dec 2012 19:47:47 -0300
Message-Id: <1355266103-17238-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

Was ignoring the dso type (function vs. variable) and was therefore
printing bogus information.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20121120095101.GA5939@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index d6d9a46..be43785 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -583,7 +583,7 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 	if (dso->short_name != dso->long_name)
 		ret += fprintf(fp, "%s, ", dso->long_name);
 	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
-		       dso->loaded ? "" : "NOT ");
+		       dso__loaded(dso, type) ? "" : "NOT ");
 	ret += dso__fprintf_buildid(dso, fp);
 	ret += fprintf(fp, ")\n");
 	for (nd = rb_first(&dso->symbols[type]); nd; nd = rb_next(nd)) {
-- 
1.7.9.2.358.g22243

