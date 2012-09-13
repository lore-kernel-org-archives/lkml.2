Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab2IMEVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:21:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52888 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2IMEVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:21:20 -0400
X-AuditID: 9c93016f-b7b16ae000007205-7a-50515f3d969d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH] perf record: Add missing perf_hpp__init for pipe-mode
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
	<tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
	<20120912172641.GB29278@erda.amd.com>
	<20120912184815.GC557@infradead.org>
	<87y5ke8wxv.fsf@sejong.aot.lge.com>
Date: Thu, 13 Sep 2012 13:14:30 +0900
In-Reply-To: <87y5ke8wxv.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 13 Sep 2012 11:43:08 +0900")
Message-ID: <87txv28spl.fsf_-_@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf_hpp__init() function was only called from setup_browser() so
that the pipe-mode missed the initialization thus didn't respond to
related options.  Fix it.

Reported-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 97b2e6300f4c..279155a47d1c 100644
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
 
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
-- 
1.7.11.4

