Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1JSSYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:24:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42630 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1JSSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/7] perf script: Fix unknown feature comment
Date: Wed, 19 Oct 2011 16:23:34 -0200
Message-Id: <1319048618-9790-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

"perf script -v" emits:

unknown feature 3, continuing...
unknown feature 4, continuing...
unknown feature 5, continuing...
unknown feature 6, continuing...
unknown feature 7, continuing...
unknown feature 8, continuing...
unknown feature 9, continuing...
unknown feature 10, continuing...
unknown feature 11, continuing...
unknown feature 12, continuing...
unknown feature 13, continuing...
unknown feature 14, continuing...

These are all new features added by fbe96f2. Update
perf_file_section__process to know they are valid feature ids.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1318984464-20650-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2143a32..3724707 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1895,6 +1895,21 @@ static int perf_file_section__process(struct perf_file_section *section,
 		if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
 			pr_debug("Failed to read buildids, continuing...\n");
 		break;
+
+	case HEADER_HOSTNAME:
+	case HEADER_OSRELEASE:
+	case HEADER_VERSION:
+	case HEADER_ARCH:
+	case HEADER_NRCPUS:
+	case HEADER_CPUDESC:
+	case HEADER_CPUID:
+	case HEADER_TOTAL_MEM:
+	case HEADER_CMDLINE:
+	case HEADER_EVENT_DESC:
+	case HEADER_CPU_TOPOLOGY:
+	case HEADER_NUMA_TOPOLOGY:
+		break;
+
 	default:
 		pr_debug("unknown feature %d, continuing...\n", feat);
 	}
-- 
1.6.2.5

