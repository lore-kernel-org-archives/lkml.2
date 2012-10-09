Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2JIRUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:20:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2JIRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:20:40 -0400
Date: Tue, 9 Oct 2012 10:20:19 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ee76120e2d13a2d4eb0cc88da8a8e7f7909cc276@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1349413336-26936-3-git-send-email-namhyung@kernel.org>
References: <1349413336-26936-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Explicitly enable system-wide mode if no option is given
Git-Commit-ID: ee76120e2d13a2d4eb0cc88da8a8e7f7909cc276
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:20:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee76120e2d13a2d4eb0cc88da8a8e7f7909cc276
Gitweb:     http://git.kernel.org/tip/ee76120e2d13a2d4eb0cc88da8a8e7f7909cc276
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 5 Oct 2012 14:02:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 12:48:51 -0300

perf trace: Explicitly enable system-wide mode if no option is given

When no target cpu/user/task option is given, perf trace will do its job
system wide for all online cpus.  Make it explicit to reduce possible
confusion when reading code.

No functional changes intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349413336-26936-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f01fa6f..da1183f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -343,5 +343,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		return err;
 	}
 
+	if (perf_target__none(&trace.opts.target))
+		trace.opts.target.system_wide = true;
+
 	return trace__run(&trace);
 }
