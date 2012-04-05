Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2DEQ0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:26:41 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:23049
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab2DEQ0i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:26:38 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzc89bhzz1202hzz8275bhz2dh668h839h93fhd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LO9-01-4MU-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/4] perf tools: Fix include header files in util/parse-events.h
Date: Thu, 5 Apr 2012 18:26:25 +0200
Message-ID: <1333643188-26895-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/parse-events.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 6d7c74b..ab6ebe0 100644
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
1.7.8.4


