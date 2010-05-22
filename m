Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0EVRpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:45:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0EVRp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:45:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/3] perf tui: Remove annotate from popup menu after failure
Date: Sat, 22 May 2010 14:45:11 -0300
Message-Id: <1274550312-16600-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274550312-16600-1-git-send-email-acme@infradead.org>
References: <1274550312-16600-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 0b45658..c65838c 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -914,6 +914,9 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 
 			switch (toupper(es.u.key)) {
 			case 'A':
+				if (browser->selection->map == NULL &&
+				    browser->selection->map->dso->annotate_warned)
+					continue;
 				goto do_annotate;
 			case 'D':
 				goto zoom_dso;
@@ -957,6 +960,7 @@ do_help:
 		}
 
 		if (browser->selection->sym != NULL &&
+		    !browser->selection->map->dso->annotate_warned &&
 		    asprintf(&options[nr_options], "Annotate %s",
 			     browser->selection->sym->name) > 0)
 			annotate = nr_options++;
@@ -991,6 +995,7 @@ do_help:
 			struct hist_entry *he;
 do_annotate:
 			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
+				browser->selection->map->dso->annotate_warned = 1;
 				ui_helpline__puts("No vmlinux file found, can't "
 						 "annotate with just a "
 						 "kallsyms file");
-- 
1.6.2.5

