Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1BPCEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:04:00 -0500
Received: from kroah.org ([198.145.64.141]:49057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373Ab1BPBug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:00 2011
Message-Id: <20110216014700.587884093@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [063/115] klist: Fix object alignment on 64-bit.
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 include/linux/klist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


