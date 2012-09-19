Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2ISPZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:25:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2ISPZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:25:28 -0400
Date: Wed, 19 Sep 2012 08:25:06 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-60e5c706b3ea56f87afc2a4a3096118d28f9cc24@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, robert.richter@amd.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <87txv28spl.fsf_-_@sejong.aot.lge.com>
References: <87txv28spl.fsf_-_@sejong.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Add missing perf_hpp__init for pipe-mode
Git-Commit-ID: 60e5c706b3ea56f87afc2a4a3096118d28f9cc24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:25:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60e5c706b3ea56f87afc2a4a3096118d28f9cc24
Gitweb:     http://git.kernel.org/tip/60e5c706b3ea56f87afc2a4a3096118d28f9cc24
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 13 Sep 2012 13:14:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:11:33 -0300

perf report: Add missing perf_hpp__init for pipe-mode

The perf_hpp__init() function was only called from setup_browser() so
that the pipe-mode missed the initialization thus didn't respond to
related options.  Fix it.

Reported-by: Robert Richter <robert.richter@amd.com>
Tested-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
Link: http://lkml.kernel.org/r/87txv28spl.fsf_-_@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b6696dd..1da243d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -689,8 +689,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (strcmp(report.input_name, "-") != 0)
 		setup_browser(true);
-	else
+	else {
 		use_browser = 0;
+		perf_hpp__init(false, false);
+	}
 
 	setup_sorting(report_usage, options);
 
