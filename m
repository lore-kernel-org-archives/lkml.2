Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab0C3Xa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:30:29 -0400
Received: from kroah.org ([198.145.64.141]:46679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602Ab0C3XVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:42 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:43 2010
Message-Id: <20100330224843.349203460@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Hendry <andrew.hendry@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [127/156] x25: use limited socket backlog
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

[ Upstream commit 2499849ee8f513e795b9f2c19a42d6356e4943a4 ]

Make x25 adapt to the limited socket backlog change.

Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/x25_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -53,7 +53,7 @@ static int x25_receive_data(struct sk_bu
 		if (!sock_owned_by_user(sk)) {
 			queued = x25_process_rx_frame(sk, skb);
 		} else {
-			sk_add_backlog(sk, skb);
+			queued = !sk_add_backlog_limited(sk, skb);
 		}
 		bh_unlock_sock(sk);
 		sock_put(sk);


