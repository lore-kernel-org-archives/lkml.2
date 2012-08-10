Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2HJG5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:57:45 -0400
Received: from mail1.windriver.com ([147.11.146.13]:64883 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2HJG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:57:37 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <teigland@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] dlm: convert add_sock routine return value type to void
Date: Fri, 10 Aug 2012 14:58:42 +0800
Message-ID: <1344581922-19619-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since add_sock() always returns a success code - 0, its return
value type should be changed from integer to void.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 fs/dlm/lowcomms.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index e7b0ac0..8789309 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -348,7 +348,7 @@ int dlm_lowcomms_connect_node(int nodeid)
 }
 
 /* Make a socket active */
-static int add_sock(struct socket *sock, struct connection *con)
+static void add_sock(struct socket *sock, struct connection *con)
 {
 	con->sock = sock;
 
@@ -358,7 +358,6 @@ static int add_sock(struct socket *sock, struct connection *con)
 	con->sock->sk->sk_state_change = lowcomms_state_change;
 	con->sock->sk->sk_user_data = con;
 	con->sock->sk->sk_allocation = GFP_NOFS;
-	return 0;
 }
 
 /* Add the port number to an IPv6 or 4 sockaddr and return the address
-- 
1.7.11

