Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2IJEwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:52:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33982 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:52:03 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:52:02 +0800
Message-ID: <CAPgLHd_Frq8JPUZW9FuzeZ=sQumVkc=HyxwWPLFwHdgDzmx+kg@mail.gmail.com>
Subject: [PATCH] hwspinlock/core: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ohad@wizery.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hwspinlock/hwspinlock_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 1201a15..db713c0 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -552,7 +552,7 @@ EXPORT_SYMBOL_GPL(hwspin_lock_request_specific);
  */
 int hwspin_lock_free(struct hwspinlock *hwlock)
 {
-	struct device *dev = hwlock->bank->dev;
+	struct device *dev;
 	struct hwspinlock *tmp;
 	int ret;
 
@@ -561,6 +561,7 @@ int hwspin_lock_free(struct hwspinlock *hwlock)
 		return -EINVAL;
 	}
 
+	dev = hwlock->bank->dev;
 	mutex_lock(&hwspinlock_tree_lock);
 
 	/* make sure the hwspinlock is used */

