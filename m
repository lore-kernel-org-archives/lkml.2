Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1JSAed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:34:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55594 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1JSAeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:34:31 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, eranian@google.com
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf script: fix unknown feature comment
Date: Tue, 18 Oct 2011 18:34:24 -0600
Message-Id: <1318984464-20650-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
perf_file_section__process to know they are valid feature
ids.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 65627a3..6a9c041 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1915,6 +1915,21 @@ static int perf_file_section__process(struct perf_file_section *section,
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
1.7.6.4

