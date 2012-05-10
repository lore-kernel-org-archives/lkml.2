Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2EJRR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:17:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2EJRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/16] perf top: Update event name when falling back to cpu-clock
Date: Thu, 10 May 2012 14:17:42 -0300
Message-Id: <1336670265-20401-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The 'perf top' command falls back to cpu-clock if the H/W cycles event
is not supported, but the event name is not updated leading to a
misleading header:

PerfTop: 8 irqs/sec  kernel:75.0%  exact:  0.0% [1000Hz cycles],  ...

Update the event name when the event type is changed so that the
header displays correctly:

PerfTop: 794 irqs/sec  kernel:100.0%  exact:  0.0% [1000Hz cpu-clock], ...

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336495789-58420-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c53cdab..4eb6171 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,6 +948,10 @@ try_again:
 
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				if (counter->name) {
+					free(counter->name);
+					counter->name = strdup(event_name(counter));
+				}
 				goto try_again;
 			}
 
-- 
1.7.9.2.358.g22243

