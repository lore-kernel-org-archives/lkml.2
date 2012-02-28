Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965262Ab2B1BY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:24:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64391 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965437Ab2B1BTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.194.8 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.366840560@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        WANG Cong <amwang@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/72] netpoll: netpoll_poll_dev() should access dev->flags
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 58e05f357a039a94aa36475f8c110256f693a239 ]

commit 5a698af53f (bond: service netpoll arp queue on master device)
tested IFF_SLAVE flag against dev->priv_flags instead of dev->flags

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: WANG Cong <amwang@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -194,7 +194,7 @@ static void netpoll_poll_dev(struct net_
 
 	poll_napi(dev);
 
-	if (dev->priv_flags & IFF_SLAVE) {
+	if (dev->flags & IFF_SLAVE) {
 		if (dev->npinfo) {
 			struct net_device *bond_dev = dev->master;
 			struct sk_buff *skb;


