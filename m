Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2EHQuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:50:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48530 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236Ab2EHQuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:50:17 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf record: reset event name when falling back to cpu-clock
Date: Tue,  8 May 2012 10:50:11 -0600
Message-Id: <1336495811-58461-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-record defaults to the H/W cycles event and if it is
not supported falls back to cpu-clock. Reset the event name
as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 42e2414..42d0fcf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -252,6 +252,10 @@ try_again:
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
1.7.5.4

