Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2DARub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:50:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41794 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2DARtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:49:40 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 3/8] net/ipv6/datagram.c: Checkpatch cleanups
Date: Sun,  1 Apr 2012 19:49:03 +0200
Message-Id: <1333302548-9187-3-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

datagram.c:101: ERROR: "(foo*)" should be "(foo *)"
datagram.c:521: ERROR: space required before the open parenthesis '('
datagram.c:830: WARNING: braces {} are not necessary for single statement blocks
datagram.c:849: WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv6/datagram.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 76832c8..f6210d6 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -98,7 +98,7 @@ int ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		sin.sin_port = usin->sin6_port;
 
 		err = ip4_datagram_connect(sk,
-					   (struct sockaddr*) &sin,
+					   (struct sockaddr *) &sin,
 					   sizeof(sin));
 
 ipv4_connected:
@@ -518,7 +518,7 @@ int datagram_recv_ctl(struct sock *sk, struct msghdr *msg, struct sk_buff *skb)
 			unsigned len;
 			u8 *ptr = nh + off;
 
-			switch(nexthdr) {
+			switch (nexthdr) {
 			case IPPROTO_DSTOPTS:
 				nexthdr = ptr[0];
 				len = (ptr[1] + 1) << 3;
@@ -827,9 +827,8 @@ int datagram_send_ctl(struct net *net, struct sock *sk,
 			int tc;
 
 			err = -EINVAL;
-			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int))) {
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
 				goto exit_f;
-			}
 
 			tc = *(int *)CMSG_DATA(cmsg);
 			if (tc < -1 || tc > 0xff)
@@ -846,9 +845,8 @@ int datagram_send_ctl(struct net *net, struct sock *sk,
 			int df;
 
 			err = -EINVAL;
-			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int))) {
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
 				goto exit_f;
-			}
 
 			df = *(int *)CMSG_DATA(cmsg);
 			if (df < 0 || df > 1)
-- 
1.7.9.5

