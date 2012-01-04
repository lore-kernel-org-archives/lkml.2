Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2ADPUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:20:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2ADPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:20:48 -0500
Date: Wed, 4 Jan 2012 07:20:23 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-29c9862f1b818bf4caa4c48a30dbe5f25c84ee08@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
References: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Remove impossible condition check
Git-Commit-ID: 29c9862f1b818bf4caa4c48a30dbe5f25c84ee08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Jan 2012 07:20:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29c9862f1b818bf4caa4c48a30dbe5f25c84ee08
Gitweb:     http://git.kernel.org/tip/29c9862f1b818bf4caa4c48a30dbe5f25c84ee08
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 28 Dec 2011 00:35:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 3 Jan 2012 14:35:02 -0200

perf session: Remove impossible condition check

The 'size' cannot be 0 because it was set to 8 on the above line in case
it was 0 and never changed.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325000151-4463-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cc5e6be..b5ca255 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1015,8 +1015,7 @@ more:
 		}
 	}
 
-	if (size == 0 ||
-	    (skip = perf_session__process_event(self, &event, tool, head)) < 0) {
+	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
 		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    head, event.header.size, event.header.type);
 		/*
