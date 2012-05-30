Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2E3Hru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:47:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2E3Hrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:47:48 -0400
Date: Wed, 30 May 2012 00:47:13 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-a00dc319e98161949aa87f71a17db32e925c3257@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        khandual@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        khandual@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120525211344.GA7729@quad>
References: <20120525211344.GA7729@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record:
  Fix branch_stack type in perf_record_opts
Git-Commit-ID: a00dc319e98161949aa87f71a17db32e925c3257
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:47:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a00dc319e98161949aa87f71a17db32e925c3257
Gitweb:     http://git.kernel.org/tip/a00dc319e98161949aa87f71a17db32e925c3257
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 25 May 2012 23:13:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 May 2012 18:32:44 -0300

perf record: Fix branch_stack type in perf_record_opts

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
 1 files changed, 1 insertions(+), 1 deletions(-)

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
