Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0EQQTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:19:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17079 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0EQQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:19:43 -0400
Date: Mon, 17 May 2010 09:17:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH -next] bridge: fix build for CONFIG_SYSFS disabled
Message-Id: <20100517091756.e232bdc2.randy.dunlap@oracle.com>
In-Reply-To: <20100517163521.649526d0.sfr@canb.auug.org.au>
References: <20100517163521.649526d0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4BF16C65.018B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build when CONFIG_SYSFS is not enabled:

net/bridge/br_if.c:136: error: 'struct net_bridge_port' has no member named 'sysfs_name'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/bridge/br_if.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20100517.orig/net/bridge/br_if.c
+++ linux-next-20100517/net/bridge/br_if.c
@@ -133,7 +133,9 @@ static void del_nbp(struct net_bridge_po
 	struct net_bridge *br = p->br;
 	struct net_device *dev = p->dev;
 
+#ifdef CONFIG_SYSFS
 	sysfs_remove_link(br->ifobj, p->sysfs_name);
+#endif
 
 	dev_set_promiscuity(dev, -1);
 
