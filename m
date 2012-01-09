Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2AIH2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:28:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2AIH2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:28:02 -0500
Date: Sun, 8 Jan 2012 23:27:40 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-6714a04114639350a7fed93edf8e1b995c5e8059@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325957132-10600-7-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-7-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Get rid of field_sep check
Git-Commit-ID: 6714a04114639350a7fed93edf8e1b995c5e8059
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 23:27:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6714a04114639350a7fed93edf8e1b995c5e8059
Gitweb:     http://git.kernel.org/tip/6714a04114639350a7fed93edf8e1b995c5e8059
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 8 Jan 2012 02:25:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 8 Jan 2012 13:29:34 -0200

perf annotate: Get rid of field_sep check

The 'field_sep' variable is not set anywhere. Just remove the
conditional.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-7-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3ec2496..806e0a2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -313,10 +313,5 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		annotate.sym_hist_filter = argv[0];
 	}
 
-	if (field_sep && *field_sep == '.') {
-		pr_err("'.' is the only non valid --field-separator argument\n");
-		return -1;
-	}
-
 	return __cmd_annotate(&annotate);
 }
