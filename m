Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1IFCgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 22:36:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37181 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab1IFCgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 22:36:45 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: Glauber Costa <glommer@parallels.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] cleanup: no need to call rcu_lock in sock_update_classid()
Date: Mon,  5 Sep 2011 23:35:36 -0300
Message-Id: <1315276536-10910-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to protect

According to the all-knowing git log, this was inserted here to prevent a
warning in commit 1144182a. But 3fb5a991 also does that in a different place.
>From reading it, I believe they are fixing the same warning, so no need
for both.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: David S. Miller <davem@davemloft.net>
---
 net/core/sock.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bc745d0..3449df8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1107,9 +1107,7 @@ void sock_update_classid(struct sock *sk)
 {
 	u32 classid;
 
-	rcu_read_lock();  /* doing current task, which cannot vanish. */
 	classid = task_cls_classid(current);
-	rcu_read_unlock();
 	if (classid && classid != sk->sk_classid)
 		sk->sk_classid = classid;
 }
-- 
1.7.6

