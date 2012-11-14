Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2KNHet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:34:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2KNHes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:34:48 -0500
Date: Tue, 13 Nov 2012 23:34:10 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-eef9ba98b9ee96f52e544b09f581c397d8cc8265@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung.kim@lge.com,
        jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung.kim@lge.com,
        jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1352123463-7346-6-git-send-email-eranian@google.com>
References: <1352123463-7346-6-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add arbitary aliases and support names with -
Git-Commit-ID: eef9ba98b9ee96f52e544b09f581c397d8cc8265
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:34:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eef9ba98b9ee96f52e544b09f581c397d8cc8265
Gitweb:     http://git.kernel.org/tip/eef9ba98b9ee96f52e544b09f581c397d8cc8265
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Nov 2012 14:50:52 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 16:12:03 -0300

perf tools: Add arbitary aliases and support names with -

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
 1 files changed, 2 insertions(+), 0 deletions(-)

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
