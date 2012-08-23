Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2HWPKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:10:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab2HWPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/12] perf tools: Keep the perf_event_attr on version 3
Date: Thu, 23 Aug 2012 12:09:51 -0300
Message-Id: <1345734596-7601-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Stashing version 4 under version 3 and removing version 4, because both
version changes were within single patchset.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/20120822083540.GB1003@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    4 ++--
 tools/perf/util/header.c   |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 297ca3d..28f9cee 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -205,8 +205,8 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
 #define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
-#define PERF_ATTR_SIZE_VER3	88	/* add: sample_regs_user */
-#define PERF_ATTR_SIZE_VER4	96	/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
+					/* add: sample_stack_user */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 63aad31..9696e64 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2011,7 +2011,6 @@ static const int attr_file_abi_sizes[] = {
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
 	[3] = PERF_ATTR_SIZE_VER3,
-	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
-- 
1.7.1

