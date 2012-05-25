Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab2EYRGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933697Ab2EYRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:45 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 01/35] mm: add unlikely to the mm allocation failure check
Date: Fri, 25 May 2012 19:02:05 +0200
Message-Id: <1337965359-29725-2-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very minor optimization to hint gcc.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 47b4e4f..98db8b0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -571,7 +571,7 @@ struct mm_struct *mm_alloc(void)
 	struct mm_struct *mm;
 
 	mm = allocate_mm();
-	if (!mm)
+	if (unlikely(!mm))
 		return NULL;
 
 	memset(mm, 0, sizeof(*mm));
