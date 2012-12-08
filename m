Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab2LHOwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:52:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346Ab2LHOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:52:51 -0500
Date: Sat, 8 Dec 2012 06:52:24 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8nodd6b4bytyf1snf96oy531@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Initialize all of he->
 stat with zeroes
Git-Commit-ID: 30193d78d82a68247aa628a2414dc0f76c5b8093
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:52:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30193d78d82a68247aa628a2414dc0f76c5b8093
Gitweb:     http://git.kernel.org/tip/30193d78d82a68247aa628a2414dc0f76c5b8093
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 12 Nov 2012 13:20:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:50:47 -0300

perf hists: Initialize all of he->stat with zeroes

Not just nr_events and period.

Reported-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8nodd6b4bytyf1snf96oy531@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7c6e73b..cb17e2a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -742,9 +742,8 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 
 	he = hist_entry__new(pair);
 	if (he) {
-		he->stat.nr_events = 0;
-		he->stat.period    = 0;
-		he->hists	   = hists;
+		memset(&he->stat, 0, sizeof(he->stat));
+		he->hists = hists;
 		rb_link_node(&he->rb_node, parent, p);
 		rb_insert_color(&he->rb_node, &hists->entries);
 		hists__inc_nr_entries(hists, he);
