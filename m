Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2KTJvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:51:08 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43952 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2KTJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:51:04 -0500
Date: Tue, 20 Nov 2012 10:51:02 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, namhyung.kim@lge.com
Subject: [PATCH] perf tools: fix dso__fprintf() print statement
Message-ID: <20121120095101.GA5939@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Was ignoring the dso type (function vs. variable) and
was therefore printing bogus information.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
