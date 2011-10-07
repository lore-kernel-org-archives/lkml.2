Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387Ab1JGL1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:27:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35965 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953Ab1JGL1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/12] drbd: Refer to connect-int consistently throughout the code
Date: Fri,  7 Oct 2011 13:27:42 +0200
Message-Id: <1317986865-3706-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   12 ++++++------
 include/linux/drbd_genl.h          |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 684f795..7deade1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -617,7 +617,7 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	struct sockaddr_in6 peer_in6;
 	struct net_conf *nc;
 	int err, peer_addr_len, my_addr_len;
-	int sndbuf_size, rcvbuf_size, try_connect_int;
+	int sndbuf_size, rcvbuf_size, connect_int;
 	int disconnect_on_error = 1;
 
 	rcu_read_lock();
@@ -629,7 +629,7 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 
 	sndbuf_size = nc->sndbuf_size;
 	rcvbuf_size = nc->rcvbuf_size;
-	try_connect_int = nc->try_connect_int;
+	connect_int = nc->connect_int;
 
 	my_addr_len = min_t(int, nc->my_addr_len, sizeof(src_in6));
 	memcpy(&src_in6, nc->my_addr, my_addr_len);
@@ -653,7 +653,7 @@ static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 	}
 
 	sock->sk->sk_rcvtimeo =
-	sock->sk->sk_sndtimeo = try_connect_int * HZ;
+	sock->sk->sk_sndtimeo = connect_int * HZ;
 	drbd_setbufsize(sock, sndbuf_size, rcvbuf_size);
 
        /* explicitly bind to the configured IP as source IP
@@ -702,7 +702,7 @@ out:
 static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn)
 {
 	int timeo, err, my_addr_len;
-	int sndbuf_size, rcvbuf_size, try_connect_int;
+	int sndbuf_size, rcvbuf_size, connect_int;
 	struct socket *s_estab = NULL, *s_listen;
 	struct sockaddr_in6 my_addr;
 	struct net_conf *nc;
@@ -717,7 +717,7 @@ static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn)
 
 	sndbuf_size = nc->sndbuf_size;
 	rcvbuf_size = nc->rcvbuf_size;
-	try_connect_int = nc->try_connect_int;
+	connect_int = nc->connect_int;
 
 	my_addr_len = min_t(int, nc->my_addr_len, sizeof(struct sockaddr_in6));
 	memcpy(&my_addr, nc->my_addr, my_addr_len);
@@ -731,7 +731,7 @@ static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn)
 		goto out;
 	}
 
-	timeo = try_connect_int * HZ;
+	timeo = connect_int * HZ;
 	timeo += (random32() & 1) ? timeo / 7 : -timeo / 7; /* 28.5% random jitter */
 
 	s_listen->sk->sk_reuse    = 1; /* SO_REUSEADDR */
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 4d76d0a..07b4f4a 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -145,7 +145,7 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__str_field_def(6,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
 	__str_field_def(7,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
 	__u32_field_def(8,	GENLA_F_MANDATORY,	wire_protocol, DRBD_PROTOCOL_DEF)
-	__u32_field_def(9,	GENLA_F_MANDATORY,	try_connect_int, DRBD_CONNECT_INT_DEF)
+	__u32_field_def(9,	GENLA_F_MANDATORY,	connect_int, DRBD_CONNECT_INT_DEF)
 	__u32_field_def(10,	GENLA_F_MANDATORY,	timeout, DRBD_TIMEOUT_DEF)
 	__u32_field_def(11,	GENLA_F_MANDATORY,	ping_int, DRBD_PING_INT_DEF)
 	__u32_field_def(12,	GENLA_F_MANDATORY,	ping_timeo, DRBD_PING_TIMEO_DEF)
-- 
1.7.4.1

