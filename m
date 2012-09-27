Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2I0FaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:30:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2I0FaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:30:22 -0400
Date: Wed, 26 Sep 2012 22:29:58 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e93699b3c7aeb13eee473b1dc36cbe3a8a0ca397@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1348474503-15070-2-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Add struct perf_session_env
Git-Commit-ID: e93699b3c7aeb13eee473b1dc36cbe3a8a0ca397
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:30:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e93699b3c7aeb13eee473b1dc36cbe3a8a0ca397
Gitweb:     http://git.kernel.org/tip/e93699b3c7aeb13eee473b1dc36cbe3a8a0ca397
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 24 Sep 2012 17:14:58 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 11:44:05 -0300

perf header: Add struct perf_session_env

The struct perf_session_env will preserve environment information at the
time of perf record.  It can be accessed anytime after parsing a
perf.data file if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1348474503-15070-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 58de08b..5867c7d 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -58,6 +58,29 @@ struct perf_header;
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd);
 
+struct perf_session_env {
+	char			*hostname;
+	char			*os_release;
+	char			*version;
+	char			*arch;
+	int			nr_cpus_online;
+	int			nr_cpus_avail;
+	char			*cpu_desc;
+	char			*cpuid;
+	unsigned long long	total_mem;
+
+	int			nr_cmdline;
+	char			*cmdline;
+	int			nr_sibling_cores;
+	char			*sibling_cores;
+	int			nr_sibling_threads;
+	char			*sibling_threads;
+	int			nr_numa_nodes;
+	char			*numa_nodes;
+	int			nr_pmu_mappings;
+	char			*pmu_mappings;
+};
+
 struct perf_header {
 	int			frozen;
 	bool			needs_swap;
@@ -67,6 +90,7 @@ struct perf_header {
 	u64			event_offset;
 	u64			event_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+	struct perf_session_env env;
 };
 
 struct perf_evlist;
