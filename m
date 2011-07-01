Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1GAPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:19:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:33280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab1GAPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:19:22 -0400
Date: Fri, 1 Jul 2011 15:19:10 GMT
From: tip-bot for Richard Kennedy <richard@rsk.demon.co.uk>
Message-ID: <tip-28009ce4a8130af7260a9271901b4419834ad152@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, richard@rsk.demon.co.uk, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, richard@rsk.demon.co.uk,
        mingo@elte.hu
In-Reply-To: <1307460819.1950.5.camel@castor.rsk>
References: <1307460819.1950.5.camel@castor.rsk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove 64-bit alignment padding from perf_event_context
Git-Commit-ID: 28009ce4a8130af7260a9271901b4419834ad152
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:19:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28009ce4a8130af7260a9271901b4419834ad152
Gitweb:     http://git.kernel.org/tip/28009ce4a8130af7260a9271901b4419834ad152
Author:     Richard Kennedy <richard@rsk.demon.co.uk>
AuthorDate: Tue, 7 Jun 2011 16:33:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:32 +0200

perf: Remove 64-bit alignment padding from perf_event_context

Reorder perf_event_context to remove 8 bytes of 64 bit alignment padding
shrinking its size to 192 bytes, allowing it to fit into a smaller slab
and use one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1307460819.1950.5.camel@castor.rsk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e76a410..2f7b5d4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -894,8 +894,8 @@ struct perf_event_context {
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
-	struct rcu_head			rcu_head;
 	int				nr_cgroups; /* cgroup events present */
+	struct rcu_head			rcu_head;
 };
 
 /*
