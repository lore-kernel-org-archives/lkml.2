Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1AWPRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:41 -0500
Received: from www.tglx.de ([62.245.132.106]:58712 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1AWPRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:39 -0500
Message-Id: <20110123143837.316836004@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jeff Dike <jdike@addtoit.com>
Subject: [patch 5/9] um: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=um-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c
+++ linux-2.6/arch/um/drivers/ubd_kern.c
@@ -185,7 +185,7 @@ struct ubd {
 	.no_cow =               0, \
 	.shared =		0, \
 	.cow =			DEFAULT_COW, \
-	.lock =			SPIN_LOCK_UNLOCKED,	\
+	.lock =			__SPIN_LOCK_UNLOCKED(ubd_devs.lock), \
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \


