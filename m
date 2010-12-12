Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0LLXsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36865 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab0LLXsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: socketcan@hartkopp.net, ak@linux.intel.com, torvalds@linux-foundation.org,
        davem@davemloft.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [207/223] can-bcm: fix minor heap overflow
Message-Id: <20101212234834.4BEDEB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0597d1b99fcfc2c0eada09a698f85ed413d4ba84 upstream.

On 64-bit platforms the ASCII representation of a pointer may be up to 17
bytes long. This patch increases the length of the buffer accordingly.

http://marc.info/?l=linux-netdev&m=128872251418192&w=2

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/bcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/can/bcm.c
===================================================================
--- linux.orig/net/can/bcm.c
+++ linux/net/can/bcm.c
@@ -125,7 +125,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [9]; /* pointer printed in ASCII with \0 */
+	char procname [20]; /* pointer printed in ASCII with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
