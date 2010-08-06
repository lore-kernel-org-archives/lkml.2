Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638Ab0HFRF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:05:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:42439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761596Ab0HFRFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:05:50 -0400
Date: Fri, 6 Aug 2010 17:05:01 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Handle verbose in hists__sort_list_width
Message-ID: <tip-903cce6eb9117550755de9bf92f3b48367b7dfe0@git.kernel.org>
Git-Commit-ID: 903cce6eb9117550755de9bf92f3b48367b7dfe0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:05:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  903cce6eb9117550755de9bf92f3b48367b7dfe0
Gitweb:     http://git.kernel.org/tip/903cce6eb9117550755de9bf92f3b48367b7dfe0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Aug 2010 19:15:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:01 -0300

perf hists: Handle verbose in hists__sort_list_width

Otherwise entries will get chopped up on the window.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e7263d4..62ec9b0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -876,6 +876,9 @@ unsigned int hists__sort_list_width(struct hists *self)
 		if (!se->elide)
 			ret += 2 + hists__col_len(self, se->se_width_idx);
 
+	if (verbose) /* Addr + origin */
+		ret += 3 + BITS_PER_LONG / 4;
+
 	return ret;
 }
 
