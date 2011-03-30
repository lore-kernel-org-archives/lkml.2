Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab1C3VGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:55099 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933308Ab1C3VGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132968"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: davem@davemloft.net, jesper.nilsson@axis.com,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [65/275] klist: Fix object alignment on 64-bit.
Message-Id: <20110330210502.1F8563E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Miller <davem@davemloft.net>

commit 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505 upstream.

Commit c0e69a5bbc6f ("klist.c: bit 0 in pointer can't be used as flag")
intended to make sure that all klist objects were at least pointer size
aligned, but used the constant "4" which only works on 32-bit.

Use "sizeof(void *)" which is correct in all cases.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/klist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/include/linux/klist.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/klist.h	2011-03-29 22:51:43.946598685 -0700
+++ linux-2.6.35.y/include/linux/klist.h	2011-03-29 23:02:59.534312087 -0700
@@ -22,7 +22,7 @@
 	struct list_head	k_list;
 	void			(*get)(struct klist_node *);
 	void			(*put)(struct klist_node *);
-} __attribute__ ((aligned (4)));
+} __attribute__ ((aligned (sizeof(void *))));
 
 #define KLIST_INIT(_name, _get, _put)					\
 	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
