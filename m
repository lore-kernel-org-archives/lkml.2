Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2JIRu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:50:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2JIRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:50:24 -0400
Date: Tue, 9 Oct 2012 10:38:22 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-b880deeaffd9df0cec9a4496447d0d7fd78086f2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1349716656-48165-7-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-7-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Remove typecast in init_kvm_event_record
Git-Commit-ID: b880deeaffd9df0cec9a4496447d0d7fd78086f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:38:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b880deeaffd9df0cec9a4496447d0d7fd78086f2
Gitweb:     http://git.kernel.org/tip/b880deeaffd9df0cec9a4496447d0d7fd78086f2
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 8 Oct 2012 11:17:30 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2012 17:14:57 -0300

perf kvm: Remove typecast in init_kvm_event_record

Not needed after changing i to unsigned int.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1349716656-48165-7-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b98095e..8416754 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -313,9 +313,9 @@ struct vcpu_event_record {
 
 static void init_kvm_event_record(struct perf_kvm *kvm)
 {
-	int i;
+	unsigned int i;
 
-	for (i = 0; i < (int)EVENTS_CACHE_SIZE; i++)
+	for (i = 0; i < EVENTS_CACHE_SIZE; i++)
 		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
