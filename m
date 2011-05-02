Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1EBBVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:21:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54596 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab1EBBUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:20:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=f2LjxE0TKaK4wFClQH3i+stDPSsPaGQQOd7fS9eg+lpzw0eoThfETvfx0BryB3fr1
	yWUQK/8+aBNdth9ktxT4w==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 09/19] sched: update division in cpu_avg_load_per_task to use div_u64
Date: Sun,  1 May 2011 18:19:07 -0700
Message-Id: <1304299157-25769-10-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the division in cpu_avg_load_per_task() to use div_u64, so
that it works on 32-bit. We do not convert avg_load_per_task to u64 since this
can be atmost 2^28, and fits into unsigned long on 32-bit.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a49ef0e..08dcd24 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1524,7 +1524,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		rq->avg_load_per_task = rq->load.weight / nr_running;
+		rq->avg_load_per_task = div_u64(rq->load.weight, nr_running);
 	else
 		rq->avg_load_per_task = 0;
 
-- 
1.7.3.1

