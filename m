Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2BAGyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:54:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60543 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab2BAGx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:53:57 -0500
Message-ID: <4F28E22A.703@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 14:56:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 6/6] cls_cgroup: remove redundant rcu_read_lock/unlock
References: <4F28E1D1.900@cn.fujitsu.com>
In-Reply-To: <4F28E1D1.900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:52:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:52:35,
	Serialize complete at 2012-02-01 14:52:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've already used rcu_read_lock/unlock inside task_classid(),
so don't use the lock/unlock pair twice in this hot path.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/core/sock.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 213c856..c0bab23 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1160,9 +1160,7 @@ void sock_update_classid(struct sock *sk)
 {
 	u32 classid;
 
-	rcu_read_lock();  /* doing current task, which cannot vanish. */
 	classid = task_cls_classid(current);
-	rcu_read_unlock();
 	if (classid && classid != sk->sk_classid)
 		sk->sk_classid = classid;
 }
-- 
1.7.3.1
