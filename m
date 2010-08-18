Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0HRJy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab0HRJyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:54:53 -0400
Date: Wed, 18 Aug 2010 05:54:47 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dhananjay Phadke <dhananjay.phadke@qlogic.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Narender Kumar <narender.kumar@qlogic.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Amerigo Wang <amwang@redhat.com>
Message-Id: <20100818095908.6606.56224.sendpatchset@localhost.localdomain>
Subject: [RFC Patch] netxen: remove firmware exports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


netxen_nic driver can store firmwares on flash, and get them porperly and
dynamically, so the firmwares may not appear in /lib/firmware/. However, netxen_nic
still exports these firmwares via modinfo, this makes our script which parses
modinfo output fail.

Probably netxen_nic has other way to export these firmwares, but not like other
modules in a stardand way. I think we can just remove these exports, but
I am not sure.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Amit Kumar Salecha <amit.salecha@qlogic.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dhananjay Phadke <dhananjay.phadke@qlogic.com>
Cc: Narender Kumar <narender.kumar@qlogic.com>

---
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index fd86e18..e8443af 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -41,10 +41,6 @@
 MODULE_DESCRIPTION("QLogic/NetXen (1/10) GbE Converged Ethernet Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(NETXEN_NIC_LINUX_VERSIONID);
-MODULE_FIRMWARE(NX_P2_MN_ROMIMAGE_NAME);
-MODULE_FIRMWARE(NX_P3_CT_ROMIMAGE_NAME);
-MODULE_FIRMWARE(NX_P3_MN_ROMIMAGE_NAME);
-MODULE_FIRMWARE(NX_UNIFIED_ROMIMAGE_NAME);
 
 char netxen_nic_driver_name[] = "netxen_nic";
 static char netxen_nic_driver_string[] = "QLogic/NetXen Network Driver v"
