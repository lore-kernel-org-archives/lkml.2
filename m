Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030605Ab2HHROB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:14:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54087 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030444Ab2HHRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:13:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/11] tools lib traceevent: Fix cast from pointer to integer for 32 bit
Date: Wed,  8 Aug 2012 14:13:41 -0300
Message-Id: <1344446028-21381-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Fixing the integer cast reported by the following warning:

 tools/lib/traceevent/event-parse.c:3488:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-5-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
1.7.9.2.358.g22243

