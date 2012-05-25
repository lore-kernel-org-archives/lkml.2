Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2EYVNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:13:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40933 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2EYVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:13:47 -0400
Date: Fri, 25 May 2012 23:13:44 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, khandual@linux.vnet.ibm.com, peterz@infradead.org,
        mingo@elte.hu
Subject: [PATCH] perf record: fix branch_stack type in perf_record_opts
Message-ID: <20120525211344.GA7729@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The attr.branch_sample_type field is defined as u64 by the API.
As such, we need to ensure the variable holding the value of the
branch stack filters is also u64 otherwise we may lose bits in
the future.

Note also that the bogus definition of the field in
perf_record_opts caused problems on big-endian PPC systems.
Thanks to Anshuman Khandual for tracking the problem on PPC.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
