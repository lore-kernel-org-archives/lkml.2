Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2EBTZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:25:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:56682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab2EBTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/15] perf tools: Fix include header files in util/parse-events.h
Date: Wed,  2 May 2012 16:24:50 -0300
Message-Id: <1335986702-9408-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Include header fixes for

... bool:

 util/parse-events.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘have_tracepoints’

... and types.h:

 util/parse-events.h:28: error: expected ‘)’ before ‘config’
 util/parse-events.h:34: error: expected declaration specifiers or ‘...’ before ‘u64’
 util/parse-events.h:45: error: expected ‘)’ before ‘type’

This happens if now other include files are included before
util/parse-events.h.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1333643188-26895-2-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ca069f8..5cb0028 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,7 +4,9 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+#include <stdbool.h>
 #include "../../../include/linux/perf_event.h"
+#include "types.h"
 
 struct list_head;
 struct perf_evsel;
-- 
1.7.9.2.358.g22243

