Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2FLBOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:14:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37486 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2FLBNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:13:42 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, tim.c.chen@linux.intel.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf: Makefile: trivial build fix
Date: Mon, 11 Jun 2012 19:13:32 -0600
Message-Id: <1339463612-30937-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

References to OUTPUT should not be followed by a '/'. When
a build output directory is not specified for this case
you get:

gcc -o builtin-annotate.o -c ... -I/util ...

which is wrong.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0eee64c..39f7574 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -155,7 +155,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
-- 
1.7.10.1

