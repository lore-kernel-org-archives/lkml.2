Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2EHQt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:49:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2EHQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:49:56 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf top: update event name when falling back to cpu-clock
Date: Tue,  8 May 2012 10:49:49 -0600
Message-Id: <1336495789-58420-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-top falls back to cpu-clock if the H/W cycles event is not
supported, but the event name is not updated leading to a
misleading header:

PerfTop: 8 irqs/sec  kernel:75.0%  exact:  0.0% [1000Hz cycles],  ...

Update the event name when the event type is changed so that the
header displays correctly:

PerfTop: 794 irqs/sec  kernel:100.0%  exact:  0.0% [1000Hz cpu-clock], ...

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-top.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c53cdab..79481c1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,6 +948,11 @@ try_again:
 
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				if (counter->name) {
+					free(counter->name);
+					counter->name = NULL;
+					counter->name = strdup(event_name(counter));
+				}
 				goto try_again;
 			}
 
-- 
1.7.5.4

