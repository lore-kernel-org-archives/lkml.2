Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1GATqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:46:50 -0400
Received: from mail.perches.com ([173.55.12.10]:3438 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab1GATnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:43:40 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 03/12] econet: Reduce switch/case indent
Date: Fri,  1 Jul 2011 12:43:04 -0700
Message-Id: <e2f659cf95b88abbdf35c7447d8a4d00d5c424dc.1309549244.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1309549243.git.joe@perches.com>
References: <cover.1309549243.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the case labels the same indent as the switch.

Simplify a default case / return (unreached)
Remove unnecessary break after return.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/econet/af_econet.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index a1d9f37..5afdc8f 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -720,23 +720,20 @@ static int econet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg
 	struct sock *sk = sock->sk;
 	void __user *argp = (void __user *)arg;
 
-	switch(cmd) {
-		case SIOCGSTAMP:
-			return sock_get_timestamp(sk, argp);
+	switch (cmd) {
+	case SIOCGSTAMP:
+		return sock_get_timestamp(sk, argp);
 
-		case SIOCGSTAMPNS:
-			return sock_get_timestampns(sk, argp);
+	case SIOCGSTAMPNS:
+		return sock_get_timestampns(sk, argp);
 
-		case SIOCSIFADDR:
-		case SIOCGIFADDR:
-			return ec_dev_ioctl(sock, cmd, argp);
-			break;
+	case SIOCSIFADDR:
+	case SIOCGIFADDR:
+		return ec_dev_ioctl(sock, cmd, argp);
 
-		default:
-			return -ENOIOCTLCMD;
 	}
-	/*NOTREACHED*/
-	return 0;
+
+	return -ENOIOCTLCMD;
 }
 
 static const struct net_proto_family econet_family_ops = {
-- 
1.7.6.rc1

