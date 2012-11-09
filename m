Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2KIVnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/21] perf tools: Add arbitary aliases and support names with -
Date: Fri,  9 Nov 2012 18:42:55 -0300
Message-Id: <1352497390-17716-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Add missing scanner symbol for arbitrary aliases inside the config
  region.

- looks nicer than _, so allow - in the event names. Used for various of
  the arch perfmon and Haswell events.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1352123463-7346-6-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.l |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c87efc1..66959fa 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -81,6 +81,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
+name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
 modifier_event	[ukhpGH]{1,8}
 modifier_bp	[rwx]{1,3}
 
@@ -168,6 +169,7 @@ period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
+{name_minus}		{ return str(yyscanner, PE_NAME); }
 }
 
 mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
-- 
1.7.9.2.358.g22243

