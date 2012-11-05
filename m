Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2KEN6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:58:03 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55103 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab2KENxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:53:15 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v2 05/16] perf, tools: Add arbitary aliases and support names with -
Date: Mon,  5 Nov 2012 14:50:52 +0100
Message-Id: <1352123463-7346-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352123463-7346-1-git-send-email-eranian@google.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Add missing scanner symbol for arbitrary aliases inside the config
region.
- looks nicer than _, so allow - in the event names. Used for various
of the arch perfmon and Haswell events.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
1.7.9.5

