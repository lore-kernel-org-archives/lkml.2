Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1ABHxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:53:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:35564 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1ABHX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 118/260] rds: fix a leak of kernel memory
Date: Sun,  2 Jan 2011 02:16:54 -0500
Message-Id: <1293952756-15010-119-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:18.0696 (UTC) FILETIME=[C9EA2480:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

commit f037590fff3005ce8a1513858d7d44f50053cc8f upstream.

struct rds_rdma_notify contains a 32 bits hole on 64bit arches,
make sure it is zeroed before copying it to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andy Grover <andy.grover@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/rds/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index e2a2b93..93aadc0 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -297,7 +297,7 @@ static int rds_still_queued(struct rds_sock *rs, struct rds_incoming *inc,
 int rds_notify_queue_get(struct rds_sock *rs, struct msghdr *msghdr)
 {
 	struct rds_notifier *notifier;
-	struct rds_rdma_notify cmsg;
+	struct rds_rdma_notify cmsg = { 0 }; /* fill holes with zero */
 	unsigned int count = 0, max_messages = ~0U;
 	unsigned long flags;
 	LIST_HEAD(copy);
-- 
1.7.3.3

