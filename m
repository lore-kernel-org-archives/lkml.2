Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3AIVBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:01:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:43490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933851Ab3AIUke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 087/123] mac802154: fix NOHZ local_softirq_pending 08 warning
Date: Wed,  9 Jan 2013 12:35:26 -0800
Message-Id: <20130109201509.784434274@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alexander Aring <alex.aring@googlemail.com>

[ Upstream commit 5ff3fec6d3fc848753c2fa30b18607358f89a202 ]

When using nanosleep() in an userspace application we get a
ratelimit warning

NOHZ: local_softirq_pending 08

for 10 times.

This patch replaces netif_rx() with netif_rx_ni() which has
to be used from process/softirq context.
The process/softirq context will be called from fakelb driver.

See linux-kernel commit 481a819 for similar fix.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/wpan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac802154/wpan.c
+++ b/net/mac802154/wpan.c
@@ -387,7 +387,7 @@ void mac802154_wpan_setup(struct net_dev
 
 static int mac802154_process_data(struct net_device *dev, struct sk_buff *skb)
 {
-	return netif_rx(skb);
+	return netif_rx_ni(skb);
 }
 
 static int


