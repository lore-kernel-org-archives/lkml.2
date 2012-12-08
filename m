Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2LHOyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:54:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49519 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab2LHOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:54:12 -0500
Date: Sat, 8 Dec 2012 06:53:26 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4f746c95f18ad4d85599d9c157da7e6da766c3d9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1352697240-422-1-git-send-email-namhyung@kernel.org>
References: <1352697240-422-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix compile error on NO_NEWT=1 build
Git-Commit-ID: 4f746c95f18ad4d85599d9c157da7e6da766c3d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:53:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f746c95f18ad4d85599d9c157da7e6da766c3d9
Gitweb:     http://git.kernel.org/tip/4f746c95f18ad4d85599d9c157da7e6da766c3d9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 12 Nov 2012 14:14:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:50:58 -0300

perf tools: Fix compile error on NO_NEWT=1 build

    CC builtin-annotate.o
In file included from util/evsel.h:10:0,
                 from util/evlist.h:8,
                 from builtin-annotate.c:20:
util/hist.h: In function ‘script_browse’:
util/hist.h:198:45: error: unused parameter ‘script_opt’ [-Werror=unused-parameter]
cc1: all warnings being treated as errors
make: *** [builtin-annotate.o] Error 1
make: *** Waiting for unfinished jobs....

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352697240-422-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1278c2c..8b091a5 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -195,7 +195,7 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
 	return 0;
 }
 
-static inline int script_browse(const char *script_opt)
+static inline int script_browse(const char *script_opt __maybe_unused)
 {
 	return 0;
 }
