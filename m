Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2EYVte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:49:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44790 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2EYVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:49:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5 v2] perf record: Fix branch_stack type in perf_record_opts
Date: Fri, 25 May 2012 18:48:59 -0300
Message-Id: <1337982539-2882-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337982539-2882-1-git-send-email-acme@infradead.org>
References: <1337982539-2882-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The attr.branch_sample_type field is defined as u64 by the API.  As
such, we need to ensure the variable holding the value of the branch
stack filters is also u64 otherwise we may lose bits in the future.

Note also that the bogus definition of the field in perf_record_opts
caused problems on big-endian PPC systems.  Thanks to Anshuman Khandual
for tracking the problem on PPC.

Reported-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120525211344.GA7729@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 14f1034..f960ccb 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -227,7 +227,7 @@ struct perf_record_opts {
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
-	int	     branch_stack;
+	u64          branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
 };
-- 
1.7.9.2.358.g22243

