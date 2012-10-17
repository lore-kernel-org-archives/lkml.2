Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2JQPQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:16:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab2JQPQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:16:43 -0400
From: Sangho Yi <antiroot@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Sangho Yi <antiroot@gmail.com>
Subject: [PATCH] tty: tty_mutex.c: Fixed coding style warning (using printk)
Date: Thu, 18 Oct 2012 00:15:13 +0900
Message-Id: <1350486913-4002-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here I fixed from printk(KERN_ERR, ... to pr_err(... on tty_mutex.c

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/tty/tty_mutex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 67feac9..2e41abe 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -19,7 +19,7 @@ static void __lockfunc tty_lock_nested(struct tty_struct *tty,
 				       unsigned int subclass)
 {
 	if (tty->magic != TTY_MAGIC) {
-		printk(KERN_ERR "L Bad %p\n", tty);
+		pr_err("L Bad %p\n", tty);
 		WARN_ON(1);
 		return;
 	}
@@ -36,7 +36,7 @@ EXPORT_SYMBOL(tty_lock);
 void __lockfunc tty_unlock(struct tty_struct *tty)
 {
 	if (tty->magic != TTY_MAGIC) {
-		printk(KERN_ERR "U Bad %p\n", tty);
+		pr_err("U Bad %p\n", tty);
 		WARN_ON(1);
 		return;
 	}
-- 
1.7.9.5

