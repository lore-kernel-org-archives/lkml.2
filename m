Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab0L0WAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:00:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:40069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0L0WAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:00:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Torok Edwin <edwintorok@gmail.com>
Subject: [PATCH 3/4] perf script: Fix event ordering settings to work with older kernels
Date: Mon, 27 Dec 2010 20:00:12 -0200
Message-Id: <1293487213-533-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1293487213-533-1-git-send-email-acme@infradead.org>
References: <1293487213-533-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If we don't use .ordering_requires_timestamps we'll end up trying to order
events with no timestamps when running on older kernels.

Problem introduced in eac23d1c.

After the last three fixes, perf scripting is back working, tested with
new perf userspace on old and new (with sample_id_all) kernels.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Torok Edwin <edwintorok@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6ef65c0..43480fd 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -117,6 +117,7 @@ static struct perf_event_ops event_ops = {
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
 	.lost = process_lost_event,
+	.ordering_requires_timestamps = true,
 	.ordered_samples = true,
 };
 
-- 
1.6.2.5

