Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab1ADIFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:05:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62548 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1ADIFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:05:45 -0500
Message-ID: <4D22D4EE.3020604@cn.fujitsu.com>
Date: Tue, 04 Jan 2011 16:06:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] sched: add __rcu annotation
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:05:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:05:25,
	Serialize complete at 2011-01-04 16:05:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __rcu annotation to :
	(struct rq)->sd

signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 5ec0615..d23b706 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -500,7 +500,7 @@ struct rq {
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
-	struct sched_domain *sd;
+	struct sched_domain __rcu *sd;
 
 	unsigned long cpu_power;
 
