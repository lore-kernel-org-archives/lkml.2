Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1GUSaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:30:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:56777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1GUSav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:30:51 -0400
Date: Thu, 21 Jul 2011 18:30:39 GMT
From: tip-bot for Richard Kennedy <richard@rsk.demon.co.uk>
Message-ID: <tip-26a148eb9c790149750f7e77da0d96029443d400@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, richard@rsk.demon.co.uk, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, richard@rsk.demon.co.uk,
        mingo@elte.hu
In-Reply-To: <1310726492.1977.5.camel@castor.rsk>
References: <1310726492.1977.5.camel@castor.rsk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reorder root_domain to remove 64 bit alignment padding
Git-Commit-ID: 26a148eb9c790149750f7e77da0d96029443d400
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:30:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26a148eb9c790149750f7e77da0d96029443d400
Gitweb:     http://git.kernel.org/tip/26a148eb9c790149750f7e77da0d96029443d400
Author:     Richard Kennedy <richard@rsk.demon.co.uk>
AuthorDate: Fri, 15 Jul 2011 11:41:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:52 +0200

sched: Reorder root_domain to remove 64 bit alignment padding

Reorder root_domain to remove 8 bytes of alignment padding on 64 bit
builds, this shrinks the size from 1736 to 1728 bytes, therefore using
one fewer cachelines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1310726492.1977.5.camel@castor.rsk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f107204..e3f0bac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -422,6 +422,7 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
+	atomic_t rto_count;
 	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
@@ -431,7 +432,6 @@ struct root_domain {
 	 * one runnable RT task.
 	 */
 	cpumask_var_t rto_mask;
-	atomic_t rto_count;
 	struct cpupri cpupri;
 };
 
