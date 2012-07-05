Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2GESUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:20:16 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37063 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab2GESUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:20:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 05/10] net: feed /dev/random with the MAC address when registering a device
Date: Thu,  5 Jul 2012 14:12:08 -0400
Message-Id: <1341511933-11169-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6df2140..46f2f0c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5542,6 +5542,9 @@ int register_netdevice(struct net_device *dev)
 	dev_hold(dev);
 	list_netdevice(dev);
 
+	if (dev->dev_addr)
+		add_device_randomness(dev->dev_addr, dev->addr_len);
+
 	/* Notify protocols, that a new device appeared. */
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
 	ret = notifier_to_errno(ret);
-- 
1.7.11.1.108.gb129051

