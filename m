Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2ISPQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:16:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2ISPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:16:14 -0400
Date: Wed, 19 Sep 2012 08:15:57 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-1af556406670f2076ea235ba8ba16da13d227e99@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
References: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add sort__has_sym
Git-Commit-ID: 1af556406670f2076ea235ba8ba16da13d227e99
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:16:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1af556406670f2076ea235ba8ba16da13d227e99
Gitweb:     http://git.kernel.org/tip/1af556406670f2076ea235ba8ba16da13d227e99
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 14 Sep 2012 17:35:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:08:59 -0300

perf tools: Add sort__has_sym

The sort__has_sym variable is for checking whether the sort_list
includes 'symbol' as a sort key.  It will be used for later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347611729-16994-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    5 +++++
 tools/perf/util/sort.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0981bc7..b5b1b92 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,6 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
+int		sort__has_sym = 0;
 int		sort__branch_mode = -1; /* -1 = means not set */
 
 enum sort_type	sort__first_dimension;
@@ -511,6 +512,10 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
+		} else if (sd->entry == &sort_sym ||
+			   sd->entry == &sort_sym_from ||
+			   sd->entry == &sort_sym_to) {
+			sort__has_sym = 1;
 		}
 
 		if (sd->taken)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e459c98..12d6347 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -31,6 +31,7 @@ extern const char *parent_pattern;
 extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
+extern int sort__has_sym;
 extern int sort__branch_mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
