Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1GUKNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:13:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:54171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab1GUKNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:13:36 -0400
Date: Thu, 21 Jul 2011 10:13:26 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-baf040a0d1ac6319725c0fe400503683ac016580@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com, mingo@elte.hu
In-Reply-To: <1310635534-4013-4-git-send-email-jolsa@redhat.com>
References: <1310635534-4013-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Make test use the preset debugfs path
Git-Commit-ID: baf040a0d1ac6319725c0fe400503683ac016580
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:13:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  baf040a0d1ac6319725c0fe400503683ac016580
Gitweb:     http://git.kernel.org/tip/baf040a0d1ac6319725c0fe400503683ac016580
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 14 Jul 2011 11:25:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 10:41:14 +0200

perf tools: Make test use the preset debugfs path

Use preset debugfs path instead of hardcoded one.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Link: http://lkml.kernel.org/r/1310635534-4013-4-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index b5cd5f5..55f4c76 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -246,8 +246,8 @@ static int trace_event__id(const char *evname)
 	int err = -1, fd;
 
 	if (asprintf(&filename,
-		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
-		     evname) < 0)
+		     "%s/syscalls/%s/id",
+		     debugfs_path, evname) < 0)
 		return -1;
 
 	fd = open(filename, O_RDONLY);
