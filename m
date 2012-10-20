Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab2JTA74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:59:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2JTA7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:59:55 -0400
Date: Fri, 19 Oct 2012 17:59:29 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-63a1a3d820c619a4dab1781cc16c110a284efded@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        markus@trippelsdorf.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        markus@trippelsdorf.de, tglx@linutronix.de
In-Reply-To: <None>
References: <None>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists browser:
  Fix off-by-two bug on the first column
Git-Commit-ID: 63a1a3d820c619a4dab1781cc16c110a284efded
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 17:59:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63a1a3d820c619a4dab1781cc16c110a284efded
Gitweb:     http://git.kernel.org/tip/63a1a3d820c619a4dab1781cc16c110a284efded
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 15 Oct 2012 18:14:35 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 13:06:05 -0300

perf hists browser: Fix off-by-two bug on the first column

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
