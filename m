Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2KNHgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:36:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44231 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2KNHg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:36:29 -0500
Date: Tue, 13 Nov 2012 23:35:10 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ff6f7778a66edc033044a6baa2459ce79519e571@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, namhyung@kernel.org,
        dsahern@gmail.com, irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, namhyung@kernel.org,
        irina.tirdea@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1352251815-12615-1-git-send-email-namhyung@kernel.org>
References: <1352251815-12615-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don'
 t try to lookup objdump for live mode
Git-Commit-ID: ff6f7778a66edc033044a6baa2459ce79519e571
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:35:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff6f7778a66edc033044a6baa2459ce79519e571
Gitweb:     http://git.kernel.org/tip/ff6f7778a66edc033044a6baa2459ce79519e571
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 7 Nov 2012 10:30:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 17:26:52 -0300

perf tools: Don't try to lookup objdump for live mode

Arnaldo reported that annotation during perf top resulted in a segfault.
It was because the env->arch was NULL and we don't set it for a live
session.  In fact, no need to look up objdump in this case since we can
use system's default (native) objdump.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352251815-12615-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 5683529..3e975cb 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -199,6 +199,13 @@ out_error:
 
 int perf_session_env__lookup_objdump(struct perf_session_env *env)
 {
+	/*
+	 * For live mode, env->arch will be NULL and we can use
+	 * the native objdump tool.
+	 */
+	if (env->arch == NULL)
+		return 0;
+
 	return perf_session_env__lookup_binutils_path(env, "objdump",
 						      &objdump_path);
 }
