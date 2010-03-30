Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab0C3X3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:29:40 -0400
Received: from kroah.org ([198.145.64.141]:46709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab0C3XVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:46 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:45 2010
Message-Id: <20100330224845.101056174@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [130/156] bonding: fix device leak on error in bond_create()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 8d6184e4881b423522136aeb3ec1cbd9c35e8813 ]

When the register_netdevice() call fails, the newly allocated device is
not freed.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4935,6 +4935,8 @@ int bond_create(struct net *net, const c
 	}
 
 	res = register_netdevice(bond_dev);
+	if (res < 0)
+		goto out_netdev;
 
 out:
 	rtnl_unlock();


