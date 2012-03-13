Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab2CMEu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:50:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab2CMEuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:50:55 -0400
Date: Mon, 12 Mar 2012 21:50:40 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-8bcd65fd29e9abfb633bfd6eedaf24b22e211f3a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1331565210-10865-2-git-send-email-eranian@google.com>
References: <1331565210-10865-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Remove duplicate annotate choice in branch view mode
Git-Commit-ID: 8bcd65fd29e9abfb633bfd6eedaf24b22e211f3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:50:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bcd65fd29e9abfb633bfd6eedaf24b22e211f3a
Gitweb:     http://git.kernel.org/tip/8bcd65fd29e9abfb633bfd6eedaf24b22e211f3a
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 12 Mar 2012 16:13:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:46:16 +0100

perf report: Remove duplicate annotate choice in branch view mode

This patch removes the duplicated annotate selection when
browsing in branch view mode. If the sym and dso oof the branch
source and target are the same, then only one annotate choice is
proposed.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1331565210-10865-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/ui/browsers/hists.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 951e2e9..40fd424 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -989,6 +989,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			    bi &&
 			    bi->to.sym != NULL &&
 			    !bi->to.map->dso->annotate_warned &&
+			    (bi->to.sym != bi->from.sym ||
+			     bi->to.map->dso != bi->from.map->dso) &&
 				asprintf(&options[nr_options], "Annotate %s",
 					 bi->to.sym->name) > 0)
 				annotate_t = nr_options++;
