Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0CXSDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:03:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:42397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab0CXSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:02:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/6] perf annotate: Allow specifying DSOs where to look for symbol
Date: Wed, 24 Mar 2010 15:02:36 -0300
Message-Id: <1269453758-27044-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269453758-27044-1-git-send-email-acme@infradead.org>
References: <1269453758-27044-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using the same parameter as in 'perf report', allowing to specify just
one and disambiguate between DSOs that have the symbol name of interest.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 003f7dc..887e8e0 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -591,6 +591,8 @@ static const char * const annotate_usage[] = {
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
+	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
 	OPT_STRING('s', "symbol", &sym_hist_filter, "symbol",
 		    "symbol to annotate"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-- 
1.6.2.5

