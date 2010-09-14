Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0INTzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0INTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] misdn: kill big kernel lock
Date: Tue, 14 Sep 2010 21:55:20 +0200
Message-Id: <1284494124-7384-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wloMYwoRpPeqd0WKJDkJW7wVL0bcnHeKvvprCJhpE5u
 HjamwQ1Lz2jl9kR/Ir3aJtl1wFKRwQR/yEjJiNxvoA8+hsoxaC
 eB1VT1QQiHJYzeEs7npX9c0+ZpENnD0TJuBtQKN0Mt7XLN2cEa
 Vjegnavfqe2IKYMzKHz/WNXj6uOiN2m8trhHLaYg4544vC2Cir
 SghAyKqtkLl+X8slXyF8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of the big kernel lock in misdn is completely
bogus, so let's just remove it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/mISDN/stack.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index b159bd5..a5b632e 100644
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/mISDNif.h>
 #include <linux/kthread.h>
-#include <linux/smp_lock.h>
 #include "core.h"
 
 static u_int	*debug;
@@ -205,13 +204,7 @@ mISDNStackd(void *data)
 	struct mISDNstack *st = data;
 	int err = 0;
 
-#ifdef CONFIG_SMP
-	lock_kernel();
-#endif
 	sigfillset(&current->blocked);
-#ifdef CONFIG_SMP
-	unlock_kernel();
-#endif
 	if (*debug & DEBUG_MSG_THREAD)
 		printk(KERN_DEBUG "mISDNStackd %s started\n",
 		    dev_name(&st->dev->dev));
-- 
1.7.1

