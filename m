Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab2I1Syk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:54:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab2I1Syg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:54:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 019/262] l2tp: fix info leak via getsockname()
Date: Fri, 28 Sep 2012 11:49:08 -0700
Message-Id: <20120928183000.225333743@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 04d4fbca1017c11381e7d82acea21dd741e748bc ]

The L2TP code for IPv6 fails to initialize the l2tp_unused member of
struct sockaddr_l2tpip6 and that for leaks two bytes kernel stack via
the getsockname() syscall. Initialize l2tp_unused with 0 to avoid the
info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -410,6 +410,7 @@ static int l2tp_ip6_getname(struct socke
 	lsa->l2tp_family = AF_INET6;
 	lsa->l2tp_flowinfo = 0;
 	lsa->l2tp_scope_id = 0;
+	lsa->l2tp_unused = 0;
 	if (peer) {
 		if (!lsk->peer_conn_id)
 			return -ENOTCONN;


