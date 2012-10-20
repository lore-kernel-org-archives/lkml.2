Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab2JTBFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:05:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137Ab2JTBFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:05:38 -0400
Date: Fri, 19 Oct 2012 18:05:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-w3lcbx0fx1fnh3l2cbq40q2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists browser:
  Add back callchain folding symbol
Git-Commit-ID: 88a21d2f07d2a4bec2e3e03dd50a39683b938b10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:05:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88a21d2f07d2a4bec2e3e03dd50a39683b938b10
Gitweb:     http://git.kernel.org/tip/88a21d2f07d2a4bec2e3e03dd50a39683b938b10
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 17 Oct 2012 13:54:08 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Oct 2012 13:54:08 -0300

perf hists browser: Add back callchain folding symbol

The commit 5395a04841fc ("perf hists: Separate overhead and baseline
columns") makes the "Overhead" column no more the first one, this
caused the test that checks if it is time to show if a histogram
entry has callchains never hits.

Fix it by checking if the 'i' variable is equal to PERF_HPP__OVERHEAD
instead of 0.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-w3lcbx0fx1fnh3l2cbq40q2e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index fe4430a..ef2f93c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -647,7 +647,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 				ui_browser__set_percent_color(&browser->b, percent, current_entry);
 
-				if (i == 0 && symbol_conf.use_callchain) {
+				if (i == PERF_HPP__OVERHEAD && symbol_conf.use_callchain) {
 					slsmg_printf("%c ", folded_sign);
 					width -= 2;
 				}
