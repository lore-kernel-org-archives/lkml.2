Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0C3XWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:22:41 -0400
Received: from kroah.org ([198.145.64.141]:46650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab0C3XVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:41 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:43 2010
Message-Id: <20100330224842.693451249@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jon Maloy <jon.maloy@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>,
       Zhu Yi <yi.zhu@intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [126/156] tipc: use limited socket backlog
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

[ Upstream commit 53eecb1be5ae499d399d2923933937a9ea1a284f ]

Make tipc adapt to the limited socket backlog change.

Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Allan Stephens <allan.stephens@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/tipc/socket.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1322,8 +1322,10 @@ static u32 dispatch(struct tipc_port *tp
 	if (!sock_owned_by_user(sk)) {
 		res = filter_rcv(sk, buf);
 	} else {
-		sk_add_backlog(sk, buf);
-		res = TIPC_OK;
+		if (sk_add_backlog_limited(sk, buf))
+			res = TIPC_ERR_OVERLOAD;
+		else
+			res = TIPC_OK;
 	}
 	bh_unlock_sock(sk);
 


