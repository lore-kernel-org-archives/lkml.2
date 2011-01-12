Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1ALKxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:53:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:48108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab1ALKxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:53:06 -0500
Date: Wed, 12 Jan 2011 10:52:37 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] Revert "perf tools: Emit clearer message for sys_perf_event_open ENOENT return"
Message-ID: <tip-4ad9f594d7199c99f6b1b3ef88c64bd5920a4592@git.kernel.org>
Git-Commit-ID: 4ad9f594d7199c99f6b1b3ef88c64bd5920a4592
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 Jan 2011 10:52:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ad9f594d7199c99f6b1b3ef88c64bd5920a4592
Gitweb:     http://git.kernel.org/tip/4ad9f594d7199c99f6b1b3ef88c64bd5920a4592
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Jan 2011 16:58:54 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Jan 2011 17:31:26 -0200

Revert "perf tools: Emit clearer message for sys_perf_event_open ENOENT return"

This reverts commit aa7bc7ef73efc46d7c3a0e185eefaf85744aec98.

It removed the fallback from hardware profiling to software profiling.
.e.g., in a VM with no PMU.

Reported-by: David Ahern <daahern@cisco.com>
Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 ---
 tools/perf/builtin-top.c    |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index aa7ece3..1210e64 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -331,9 +331,6 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == ENOENT) {
-				die("%s event is not supported. ",
-				     event_name(evsel));
 			} else if (err == EINVAL && sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 568b195..05344c6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1247,8 +1247,6 @@ try_again:
 				die("Permission error - are you root?\n"
 					"\t Consider tweaking"
 					" /proc/sys/kernel/perf_event_paranoid.\n");
-			if (err == ENOENT)
-				die("%s event is not supported. ", event_name(evsel));
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
