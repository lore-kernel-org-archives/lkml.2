Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1AERhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:37:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:59787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1AERhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:37:35 -0500
Date: Wed, 5 Jan 2011 17:37:01 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, eranian@gmail.com, davem@davemloft.net,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, eranian@gmail.com, davem@davemloft.net,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
References: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix perf_event.h header usage
Message-ID: <tip-d030260ad33b482a371f999c7e9db79ef7a2111f@git.kernel.org>
Git-Commit-ID: d030260ad33b482a371f999c7e9db79ef7a2111f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 17:37:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d030260ad33b482a371f999c7e9db79ef7a2111f
Gitweb:     http://git.kernel.org/tip/d030260ad33b482a371f999c7e9db79ef7a2111f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 4 Jan 2011 16:30:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Jan 2011 14:52:54 -0200

perf tools: Fix perf_event.h header usage

This patch fixes the usage of the perf_event.h header file
between command modules and the supporting code in util.

It is necessary to ensure that ALL files use the SAME
perf_event.h header from the kernel source tree.

There were a couple of #include <linux/perf_event.h> mixed
with #include "../../perf_event.h".

This caused issues on some distros because of mismatch
in the layout of struct perf_event_attr. That eventually
led perf stat to segfault.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@gmail.com>
LKML-Reference: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/parse-events.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 863d78d..a0ccd69 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
  
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1c9043c..b82cafb 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,7 +4,7 @@
  * Parse symbolic events/counts passed in as options:
  */
 
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 
 struct list_head;
 struct perf_evsel;
