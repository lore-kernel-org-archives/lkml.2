Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2LCOhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:37:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43980 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932462Ab2LCOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:04 -0500
Message-Id: <20121203143151.142644093@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [ 26/89] net: correct check in dev_addr_del()
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit a652208e0b52c190e57f2a075ffb5e897fe31c3b ]

Check (ha->addr == dev->dev_addr) is always true because dev_addr_init()
sets this. Correct the check to behave properly on addr removal.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev_addr_lists.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 277faef..0387da0 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -308,7 +308,8 @@ int dev_addr_del(struct net_device *dev, unsigned char *addr,
 	 */
 	ha = list_first_entry(&dev->dev_addrs.list,
 			      struct netdev_hw_addr, list);
-	if (ha->addr == dev->dev_addr && ha->refcount == 1)
+	if (!memcmp(ha->addr, addr, dev->addr_len) &&
+	    ha->type == addr_type && ha->refcount == 1)
 		return -ENOENT;
 
 	err = __hw_addr_del(&dev->dev_addrs, addr, dev->addr_len,


