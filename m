Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0LATVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:21:54 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51977 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab0LATVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:21:53 -0500
From: Jay Vosburgh <fubar@us.ibm.com>
To: David Strand <dpstrand@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the slaves mac address
In-reply-to: <AANLkTinXD6p25BoN0+JuvFM9v6K-oibOAFJebP08F29N@mail.gmail.com>
References: <AANLkTinXD6p25BoN0+JuvFM9v6K-oibOAFJebP08F29N@mail.gmail.com>
Comments: In-reply-to David Strand <dpstrand@gmail.com>
   message dated "Wed, 01 Dec 2010 11:15:10 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Wed, 01 Dec 2010 11:21:08 -0800
Message-ID: <27001.1291231268@death>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Strand <dpstrand@gmail.com>

Restore the check for an unassigned mac address before adopting the
first slaves as it's own. The change in behavior was introduced by:

commit c20811a79e671a6a1fe86a8c1afe04aca8a7f085
Author: Jiri Pirko <jpirko@redhat.com>

    bonding: move dev_addr cpy to bond_enslave


Signed-off-by: David Strand <dpstrand@gmail.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

---
diff -uprN a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c	2010-11-24 11:36:58.125640000 -0800
+++ b/drivers/net/bonding/bond_main.c	2010-12-01 10:12:33.728640001 -0800
@@ -1576,7 +1576,7 @@ int bond_enslave(struct net_device *bond

 	/* If this is the first slave, then we need to set the master's hardware
 	 * address to be the same as the slave's. */
-	if (bond->slave_cnt == 0)
+	if (is_zero_ether_addr(bond->dev->dev_addr))
 		memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
 		       slave_dev->addr_len);
