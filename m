Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2HGRot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:49 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:3036 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855Ab2HGRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8EBY6-02-01E-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/6] perf, tools: Fix cast from pointer to integer for 32 bit
Date: Tue, 7 Aug 2012 19:43:14 +0200
Message-ID: <1344361396-7237-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the integer cast reported by the following warning:

 tools/lib/traceevent/event-parse.c:3488:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/lib/traceevent/event-parse.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5f34aa3..b7c2c49 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -31,6 +31,7 @@
 #include <stdarg.h>
 #include <ctype.h>
 #include <errno.h>
+#include <stdint.h>
 
 #include "event-parse.h"
 #include "event-utils.h"
@@ -3485,7 +3486,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			if (!string->str)
 				die("malloc str");
 
-			args[i] = (unsigned long long)string->str;
+			args[i] = (uintptr_t)string->str;
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
-- 
1.7.8.4


