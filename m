Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2L0JOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:14:45 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59226 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2L0JMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:30 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-15-50dc10fb6bd1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/10] perf sort: Align cpu column to right
Date: Thu, 27 Dec 2012 18:11:41 +0900
Message-Id: <1356599507-14226-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since cpu number is a natural number, it'd be more appropriate
aligning it to right.

Before:

  # Overhead  CPU      Command:  Pid          Shared Object
  # ........  ...  .................  .....................
  #
       8.91%  8    gnome-shell: 1497  perf-1497.map
       8.90%  7    gnome-shell: 1497  perf-1497.map
       8.86%  9    gnome-shell: 1497  perf-1497.map
       8.83%  6    gnome-shell: 1497  perf-1497.map
       8.81%  10   gnome-shell: 1497  perf-1497.map
       7.44%  5    gnome-shell: 1497  perf-1497.map
       6.20%  3    gnome-shell: 1497  perf-1497.map
       5.10%  0    gnome-shell: 1497  perf-1497.map

After:

  # Overhead  CPU      Command:  Pid          Shared Object
  # ........  ...  .................  .....................
  #
       8.91%    8  gnome-shell: 1497  perf-1497.map
       8.90%    7  gnome-shell: 1497  perf-1497.map
       8.86%    9  gnome-shell: 1497  perf-1497.map
       8.83%    6  gnome-shell: 1497  perf-1497.map
       8.81%   10  gnome-shell: 1497  perf-1497.map
       7.44%    5  gnome-shell: 1497  perf-1497.map
       6.20%    3  gnome-shell: 1497  perf-1497.map
       5.10%    0  gnome-shell: 1497  perf-1497.map

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 8b6d70bd749b..a36051b34901 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -331,7 +331,7 @@ sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
+	return repsep_snprintf(bf, size, "%*d", width, self->cpu);
 }
 
 struct sort_entry sort_cpu = {
-- 
1.7.11.7

