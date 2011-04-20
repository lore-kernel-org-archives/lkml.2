Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1DTUwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47359 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1DTUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:51:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=xvEDrE/CILhHXNFgPhWjNTuehS8qyVBwSH6Fql/D5apjUP2uSAcKLGfDBtHGIMxOX
	z4svpKm/9PIc0wNBO+b6w==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 07/18] sched: update find_idlest_cpu() to use u64 for load
Date: Wed, 20 Apr 2011 13:51:26 -0700
Message-Id: <1303332697-16426-8-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_idlest_cpu() compares load across runqueues which is now using u64.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8d8d11c..0b36548 100644
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

