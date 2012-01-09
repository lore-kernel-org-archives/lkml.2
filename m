Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2AIVqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:46:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36280 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab2AIVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:46:32 -0500
Date: Mon, 09 Jan 2012 13:44:28 -0800 (PST)
Message-Id: <20120109.134428.1344005477076228276.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 9 (net/core/sock.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F0B5302.5050105@xenotime.net>
References: <20120109170457.4465dfc66a0eace4a2230fef@canb.auug.org.au>
	<4F0B5302.5050105@xenotime.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 09 Jan 2012 13:44:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 09 Jan 2012 12:50:10 -0800

> On 01/08/2012 10:04 PM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20120106:
>> 
>> The net tree gained a build failure for which I applied a patch.
> 
> 
> net/core/sock.c: In function 'sk_update_clone':
> net/core/sock.c:1278:3: error: implicit declaration of function 'sock_update_memcg'

Sigh...

I'll add the following patch, the example randconfig seems to work
with it here at least:

net: Fix build with INET disabled.

> net/core/sock.c: In function 'sk_update_clone':
> net/core/sock.c:1278:3: error: implicit declaration of function 'sock_update_memcg'

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9b296ea..f944591 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -390,7 +390,6 @@ enum {
 	OVER_LIMIT,
 };
 
-#ifdef CONFIG_INET
 struct sock;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 void sock_update_memcg(struct sock *sk);
@@ -403,6 +402,5 @@ static inline void sock_release_memcg(struct sock *sk)
 {
 }
 #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
-#endif /* CONFIG_INET */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff --git a/net/core/sock.c b/net/core/sock.c
index c3ae73d..5c5af998 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -112,6 +112,7 @@
 #include <linux/highmem.h>
 #include <linux/user_namespace.h>
 #include <linux/jump_label.h>
+#include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
