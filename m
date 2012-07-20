Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2GTX13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:27:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2GTX0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:24 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Date: Fri, 20 Jul 2012 17:25:53 -0600
Message-Id: <1342826756-64663-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS cannot be used with guest mode. If user adds :p modifier set
exclude_guest as well.


Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Gleb Natapov <gleb@redhat.com>
Link: https://lkml.org/lkml/2012/7/9/264
---
 tools/perf/util/parse-events.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1aa721d..f34629b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -653,6 +653,9 @@ int parse_events_modifier(struct list_head *list, char *str)
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+			/* use of precise requires exclude_guest */
+			if (!exclude_GH)
+				eG = 1;
 		} else
 			break;
 
-- 
1.7.10.1

