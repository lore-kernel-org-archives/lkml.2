Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab1FAIvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:51:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162347Ab1FAITs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:19:48 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:21 2011
Message-Id: <20110601081120.767420753@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:23 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [053/165] net: use hlist_del_rcu() in dev_change_name()
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 786
Lines: 30


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 372b2312010bece1e36f577d6c99a6193ec54cbd ]

Using plain hlist_del() in dev_change_name() is wrong since a
concurrent reader can crash trying to dereference LIST_POISON1.

Bug introduced in commit 72c9528bab94 (net: Introduce
dev_get_by_name_rcu())

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1007,7 +1007,7 @@ rollback:
 	}
 
 	write_lock_bh(&dev_base_lock);
-	hlist_del(&dev->name_hlist);
+	hlist_del_rcu(&dev->name_hlist);
 	write_unlock_bh(&dev_base_lock);
 
 	synchronize_rcu();


