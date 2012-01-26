Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2AZVEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:04:36 -0500
Received: from 5-meo-dmt.ynet.sk ([147.175.167.220]:34224 "EHLO
	5-meo-dmt.ynet.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2AZVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:04:35 -0500
X-Spam-Flag: NO
X-Spam-Score: -0.717
Date: Thu, 26 Jan 2012 22:01:06 +0100 (CET)
From: Stefan Gula <steweg@ynet.sk>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <3280801.2791327611666778.JavaMail.root@5-MeO-DMT.ynet.sk>
Subject: [patch v2, kernel 3.2.1] RTNETLINK adjusting values of
 min_ifinfo_dump_size
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.98.170.234]
X-Mailer: Zimbra 5.0.8_GA_2462.UBUNTU6 (ZimbraWebClient - FF3.0 (Win)/5.0.8_GA_2462.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@gmail.com>

Setting link parameters on a netdevice changes the value
of if_nlmsg_size(), therefore it is necessary to recalculate
min_ifinfo_dump_size.

Signed-off-by: Stefan Gula <steweg@gmail.com>

---
V2-changelog: adjusted commit message

--- linux-3.2.1-orig/net/core/rtnetlink.c	2012-01-12 20:42:45.000000000 +0100
+++ linux/net/core/rtnetlink.c	2012-01-24 14:26:58.083219352 +0100
@@ -1506,6 +1506,9 @@ errout:
 
 	if (send_addr_notify)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
+	min_ifinfo_dump_size = max_t(u16, if_nlmsg_size(dev),
+					min_ifinfo_dump_size);
+
 	return err;
 }
