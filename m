Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab2H0ChU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 22:37:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48769 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2H0ChS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 22:37:18 -0400
From: Xi Wang <xi.wang@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] decnet: fix shutdown parameter checking
Date: Sun, 26 Aug 2012 22:37:07 -0400
Message-Id: <1346035027-2347-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allowed value of "how" is SHUT_RD/SHUT_WR/SHUT_RDWR (0/1/2),
rather than SHUTDOWN_MASK (3).

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 net/decnet/af_decnet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 2ba1a28..307c322 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1313,10 +1313,10 @@ static int dn_shutdown(struct socket *sock, int how)
 	if (scp->state == DN_O)
 		goto out;
 
-	if (how != SHUTDOWN_MASK)
+	if (how != SHUT_RDWR)
 		goto out;
 
-	sk->sk_shutdown = how;
+	sk->sk_shutdown = SHUTDOWN_MASK;
 	dn_destroy_sock(sk);
 	err = 0;
 
-- 
1.7.9.5

