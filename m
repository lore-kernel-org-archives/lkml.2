Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1EBBVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:21:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54590 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1EBBT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=hKPiUXPEViQHGIPW06em4ptTDzNDLKTPKXS87q3GlREj2kIoJCd46gBrLKhofEl9y
	1GuqCXyiTDeemd3cRON9g==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 07/19] sched: update find_idlest_cpu() to use u64 for load
Date: Sun,  1 May 2011 18:19:05 -0700
Message-Id: <1304299157-25769-8-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_idlest_cpu() compares load across runqueues which is now using u64.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1a9340c..c08324b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1578,7 +1578,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
-	unsigned long load, min_load = ULONG_MAX;
+	u64 load, min_load = ULLONG_MAX;
 	int idlest = -1;
 	int i;
 
-- 
1.7.3.1

