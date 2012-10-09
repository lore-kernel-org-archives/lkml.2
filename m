Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2JIRkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:40:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2JIRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:40:15 -0400
Date: Tue, 9 Oct 2012 10:39:18 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-e4f7637f8aefa2ad5159a1cda46fedea6eaf64fc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1349716656-48165-11-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-11-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Total count is a u64, print as so
Git-Commit-ID: e4f7637f8aefa2ad5159a1cda46fedea6eaf64fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:39:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4f7637f8aefa2ad5159a1cda46fedea6eaf64fc
Gitweb:     http://git.kernel.org/tip/e4f7637f8aefa2ad5159a1cda46fedea6eaf64fc
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 8 Oct 2012 11:17:34 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2012 17:15:25 -0300

perf kvm: Total count is a u64, print as so

remove cast and use proper type in format.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1349716656-48165-11-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 8416754..72a302e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -673,8 +673,8 @@ static void print_result(struct perf_kvm *kvm)
 		pr_info("\n");
 	}
 
-	pr_info("\nTotal Samples:%lld, Total events handled time:%.2fus.\n\n",
-		(unsigned long long)kvm->total_count, kvm->total_time / 1e3);
+	pr_info("\nTotal Samples:%" PRIu64 ", Total events handled time:%.2fus.\n\n",
+		kvm->total_count, kvm->total_time / 1e3);
 }
 
 static int process_sample_event(struct perf_tool *tool,
