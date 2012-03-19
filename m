Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2CSIHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:07:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab2CSIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:07:17 -0400
X-IronPort-AV: E=Sophos;i="4.73,611,1325433600"; 
   d="scan'208";a="4567343"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 1/4 V2] rcu: fix srcu_readers_active()
Date: Mon, 19 Mar 2012 16:12:11 +0800
Message-Id: <1332144734-9375-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:07,
	Serialize complete at 2012-03-19 16:05:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After patch "implement Peter's checking algorithm" applied,
SRCU_REF_MASK is not existed.

Also remove unused @cpu in srcu_readers_active_idx_check().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 1bed654..9e86ed7 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -108,7 +108,6 @@ static unsigned long srcu_readers_active_idx(struct srcu_struct *sp, int idx)
 
 static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
 {
-	int cpu;
 	unsigned long seq;
 
 	seq = srcu_readers_seq_idx(sp, idx);
@@ -186,7 +185,7 @@ static int srcu_readers_active(struct srcu_struct *sp)
 		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[0]);
 		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[1]);
 	}
-	return sum & SRCU_REF_MASK;
+	return sum;
 }
 
 /**
-- 
1.7.4.4

