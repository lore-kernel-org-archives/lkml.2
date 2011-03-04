Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1CDVIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:08:17 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:59043 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932582Ab1CDVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:08:12 -0500
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Subject: [PATCH 4/4] af_unix: remove unused struct sockaddr_un cruft
Date: Fri,  4 Mar 2011 22:08:03 +0100
Message-Id: <1299272883-32499-4-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.7.4.1.57.g0466.dirty
In-Reply-To: <1299272883-32499-1-git-send-email-hagen@jauu.net>
References: <1299272883-32499-1-git-send-email-hagen@jauu.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
 net/unix/af_unix.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 217fb7f..df5997d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1567,7 +1567,6 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	struct sock_iocb *siocb = kiocb_to_siocb(kiocb);
 	struct sock *sk = sock->sk;
 	struct sock *other = NULL;
-	struct sockaddr_un *sunaddr = msg->msg_name;
 	int err, size;
 	struct sk_buff *skb;
 	int sent = 0;
@@ -1590,7 +1589,6 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out_err;
 	} else {
-		sunaddr = NULL;
 		err = -ENOTCONN;
 		other = unix_peer(sk);
 		if (!other)
-- 
1.7.4.1.57.g0466.dirty

