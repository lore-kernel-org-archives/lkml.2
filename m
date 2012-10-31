Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161061Ab2JaJCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:02:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:56175 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161028Ab2JaJCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,687,1344236400"; 
   d="scan'208";a="235060074"
Date: Wed, 31 Oct 2012 02:02:41 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, eranian@google.com, mingo@kernel.org,
        namhyung@kernel.org
Subject: [PATCH] perf, tools: Fix WERROR=1 build with transction flags and
 fix browser
Message-ID: <20121031090241.GA28297@tassilo.jf.intel.com>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
 <1351643663-23828-24-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351643663-23828-24-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And one additional patch for this one to fix the WERROR=0 build again

---
- Fix the WERROR=1 build by avoiding some warnings
- Add a missing hunk to make the transaction flags display in the browser,
not only in --stdio

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5d20e11..41ddcf8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -582,7 +582,7 @@ static inline char *add_str(char *p, const char *str)
 
 static struct txbit {
 	unsigned flag;
-	char *name;
+	const char *name;
 } txbits[] = {
 	{ PERF_SAMPLE_TXN_ELISION,     "EL " },
 	{ PERF_SAMPLE_TXN_TRANSACTION, "TX " },
@@ -593,7 +593,7 @@ static struct txbit {
 	{ PERF_SAMPLE_TXN_CAPACITY,    "CAP " },
 	{ PERF_SAMPLE_TXN_MEMORY,      "MEM " },
 	{ PERF_SAMPLE_TXN_MISC,        "MISC " },
-	{}
+	{ 0, NULL }
 };
 
 static int hist_entry__transaction_snprintf(struct hist_entry *self, char *bf,
@@ -716,6 +716,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_GLOBAL_WEIGHT;
 			else if (!strcmp(sd->name, "local_weight"))
 				sort__first_dimension = SORT_LOCAL_WEIGHT;
+			else if (!strcmp(sd->name, "transaction"))
+				sort__first_dimension = SORT_TRANSACTION;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-- 
ak@linux.intel.com -- Speaking for myself only
