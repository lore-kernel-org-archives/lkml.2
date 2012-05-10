Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab2EJRWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:22:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:60471 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2EJRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/16] perf record: Reset event name when falling back to cpu-clock
Date: Thu, 10 May 2012 14:17:43 -0300
Message-Id: <1336670265-20401-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

perf-record defaults to the H/W cycles event and if it is not supported
falls back to cpu-clock. Reset the event name as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336495811-58461-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1a9098c..d19058a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -256,6 +256,10 @@ try_again:
 						    "trying to fall back to cpu-clock-ticks\n");
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				if (pos->name) {
+					free(pos->name);
+					pos->name = NULL;
+				}
 				goto try_again;
 			}
 
-- 
1.7.9.2.358.g22243

