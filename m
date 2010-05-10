Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0EJDWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 23:22:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0EJDWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 23:22:41 -0400
Message-ID: <4BE77C6B.5010402@cn.fujitsu.com>
Date: Mon, 10 May 2010 11:24:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Remove a bogus comment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment should have been removed together with uids_mutex
when removing user sched.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 8e1c8c0..7e72614 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -136,7 +136,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up, *new;
 
-	/* Make uid_hash_find() + uid_hash_insert() atomic. */
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
 	spin_unlock_irq(&uidhash_lock);
-- 
1.6.3

