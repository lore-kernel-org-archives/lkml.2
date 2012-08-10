Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab2HJC5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:57:37 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60054 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2HJC5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:57:35 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <teigland@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] dlm: remove redundant variable assignments
Date: Fri, 10 Aug 2012 10:58:37 +0800
Message-ID: <1344567517-19279-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xue Ying <ying.xue@windriver.com>

Once the tcp_create_listen_sock() is returned successfully, we
will invoke add_sock() immediately. In add_sock(), the 'con'
variable is assigned to 'sk_user_data', meanwhile, the 'sock' is
also set to 'con->sock'. So it's unnecessary to do the same thing
in tcp_create_listen_sock().

Signed-off-by: Xue Ying <ying.xue@windriver.com>
---
 fs/dlm/lowcomms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5c1b0e3..e7b0ac0 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1044,10 +1044,8 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 	if (result < 0) {
 		log_print("Failed to set SO_REUSEADDR on socket: %d", result);
 	}
-	sock->sk->sk_user_data = con;
 	con->rx_action = tcp_accept_from_sock;
 	con->connect_action = tcp_connect_to_sock;
-	con->sock = sock;
 
 	/* Bind to our port */
 	make_sockaddr(saddr, dlm_config.ci_tcp_port, &addr_len);
-- 
1.7.11

