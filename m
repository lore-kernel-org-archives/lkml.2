Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab0IXQru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:47:50 -0400
Received: from kroah.org ([198.145.64.141]:37076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932Ab0IXQe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:45 2010
Message-Id: <20100924163345.068328091@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [12/68] rds: fix a leak of kernel memory
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit f037590fff3005ce8a1513858d7d44f50053cc8f ]

struct rds_rdma_notify contains a 32 bits hole on 64bit arches,
make sure it is zeroed before copying it to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andy Grover <andy.grover@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/rds/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -296,7 +296,7 @@ static int rds_still_queued(struct rds_s
 int rds_notify_queue_get(struct rds_sock *rs, struct msghdr *msghdr)
 {
 	struct rds_notifier *notifier;
-	struct rds_rdma_notify cmsg;
+	struct rds_rdma_notify cmsg = { 0 }; /* fill holes with zero */
 	unsigned int count = 0, max_messages = ~0U;
 	unsigned long flags;
 	LIST_HEAD(copy);


