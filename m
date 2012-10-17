Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2JQRUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:20:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:46122 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2JQRUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/11] perf hists browser: Fix off-by-two bug on the first column
Date: Wed, 17 Oct 2012 14:19:41 -0300
Message-Id: <1350494387-10987-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 5395a04841fc ("perf hists: Separate overhead and baseline
columns") makes the "Overhead" column no more the first one.  So it
resulted in the mis-aligned column in the normal (non-diff) output.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/None
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0568536..fe4430a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -610,6 +610,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
+	bool first = true;
 
 	if (current_entry) {
 		browser->he_selection = entry;
@@ -633,10 +634,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			if (!perf_hpp__format[i].cond)
 				continue;
 
-			if (i) {
+			if (!first) {
 				slsmg_printf("  ");
 				width -= 2;
 			}
+			first = false;
 
 			if (perf_hpp__format[i].color) {
 				hpp.ptr = &percent;
-- 
1.7.1

