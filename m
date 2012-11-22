Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2KVWNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:13:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:49375 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2KVSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [ 19/38] net: correct check in dev_addr_del()
Date: Wed, 21 Nov 2012 16:40:02 -0800
Message-Id: <20121122003906.320267044@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit a652208e0b52c190e57f2a075ffb5e897fe31c3b ]

Check (ha->addr == dev->dev_addr) is always true because dev_addr_init()
sets this. Correct the check to behave properly on addr removal.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev_addr_lists.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -307,7 +307,8 @@ int dev_addr_del(struct net_device *dev,
 	 */
 	ha = list_first_entry(&dev->dev_addrs.list,
 			      struct netdev_hw_addr, list);
-	if (ha->addr == dev->dev_addr && ha->refcount == 1)
+	if (!memcmp(ha->addr, addr, dev->addr_len) &&
+	    ha->type == addr_type && ha->refcount == 1)
 		return -ENOENT;
 
 	err = __hw_addr_del(&dev->dev_addrs, addr, dev->addr_len,


