Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1BNAgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 19:36:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45933
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755225Ab1BNAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 19:36:31 -0500
Date: Sun, 13 Feb 2011 16:37:07 -0800 (PST)
Message-Id: <20110213.163707.71559850.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: jesper.nilsson@axis.com, linux-kernel@vger.kernel.org
Subject: klist: Fix object alignment on 64-bit.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit c0e69a5bbc6fc74184aa043aadb9a53bc58f953b ("klist.c: bit 0 in
pointer can't be used as flag") intended to make sure that all klist
objects were at least pointer size aligned, but used the constant "4"
which only works on 32-bit.

Use "sizeof(void *)" which is correct in all cases.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

diff --git a/include/linux/klist.h b/include/linux/klist.h
index e91a4e5..a370ce5 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -22,7 +22,7 @@ struct klist {
 	struct list_head	k_list;
 	void			(*get)(struct klist_node *);
 	void			(*put)(struct klist_node *);
-} __attribute__ ((aligned (4)));
+} __attribute__ ((aligned (sizeof(void *))));
 
 #define KLIST_INIT(_name, _get, _put)					\
 	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
