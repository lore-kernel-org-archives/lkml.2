Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2K0F6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:58:37 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57910 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2K0F6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:58:36 -0500
Message-ID: <1353995907.14050.60.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [PATCH rcu] use new nesting value for rcu_dyntick trace in
 rcu_eqs_enter_common
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, dipankar@in.ibm.com
Date: Tue, 27 Nov 2012 13:58:27 +0800
In-Reply-To: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12112705-5490-0000-0000-0000028C8CC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the real new value of dynticks_nesting instead of 0 in
rcu_eqs_enter_common(). 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7733eb5..6b7e314 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -339,7 +339,7 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 				bool user)
 {
-	trace_rcu_dyntick("Start", oldval, 0);
+	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-- 
1.7.11.4

