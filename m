Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab0DXCG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:06:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34101 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab0DXCFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=uoY7gr48S1nYZdQB9UlyWgMTEeCgP+CpJu685a2SUy5tFvOhpNShK7EAfW0hiXFS3z
         R00SLAN4TZubt3LjCN6iN+5IAg7jHfaLm8gRS4slFxHXAyi/kwvYwvdFv8hj8JQRpjAt
         3wZaYwFibaDy22JA65ISBReRHWcv8E5jRW5Lw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/9] perf: Use generic sample reordering in perf trace
Date: Sat, 24 Apr 2010 04:05:39 +0200
Message-Id: <1272074742-3654-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic sample events reordering from perf trace.
Before that, the displayed traces were ordered as they were
in the input as recorded by perf record (not time ordered).

This makes eventually perf trace displaying the events as beeing
time ordered.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2eefb33..1d034f6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -108,6 +108,7 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
+	.ordered_samples = true,
 };
 
 extern volatile int session_done;
-- 
1.6.2.3

