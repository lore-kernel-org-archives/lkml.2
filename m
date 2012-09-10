Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2IJQkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:40:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56923 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2IJQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:40:28 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 1/3] perf tool: precise mode requires exclude_guest
Date: Mon, 10 Sep 2012 10:40:14 -0600
Message-Id: <1347295216-1202-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS cannot be used with guest mode. See:
   https://lkml.org/lkml/2012/7/9/264

If user adds :p modifier set exclude_guest as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
---
 tools/perf/util/parse-events.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a031ee1..f2c02b2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -694,6 +694,9 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
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

