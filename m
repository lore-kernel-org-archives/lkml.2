Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0D0M4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:56:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:48762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab0D0M4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:56:31 -0400
Date: Tue, 27 Apr 2010 12:55:45 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
References: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix initialization bug in parse_single_tracepoint_event()
Message-ID: <tip-5710fcad7c367adefe5634dc998f1f88780a8457@git.kernel.org>
Git-Commit-ID: 5710fcad7c367adefe5634dc998f1f88780a8457
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Apr 2010 12:55:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5710fcad7c367adefe5634dc998f1f88780a8457
Gitweb:     http://git.kernel.org/tip/5710fcad7c367adefe5634dc998f1f88780a8457
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 21 Apr 2010 18:06:01 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 24 Apr 2010 03:24:09 +0200

perf: Fix initialization bug in parse_single_tracepoint_event()

The parse_single_tracepoint_event() was setting some attributes
before it validated the event was indeed a tracepoint event. This
caused problems with other initialization routines like in the
builtin-top.c module whereby sample_period is not set if not 0.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/parse-events.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3b4ec67..600d327 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -418,12 +418,6 @@ parse_single_tracepoint_event(char *sys_name,
 	u64 id;
 	int fd;
 
-	attr->sample_type |= PERF_SAMPLE_RAW;
-	attr->sample_type |= PERF_SAMPLE_TIME;
-	attr->sample_type |= PERF_SAMPLE_CPU;
-
-	attr->sample_period = 1;
-
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
 
@@ -442,6 +436,13 @@ parse_single_tracepoint_event(char *sys_name,
 	attr->type = PERF_TYPE_TRACEPOINT;
 	*strp = evt_name + evt_length;
 
+	attr->sample_type |= PERF_SAMPLE_RAW;
+	attr->sample_type |= PERF_SAMPLE_TIME;
+	attr->sample_type |= PERF_SAMPLE_CPU;
+
+	attr->sample_period = 1;
+
+
 	return EVT_HANDLED;
 }
 
