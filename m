Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0DOQls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:41:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1494 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab0DOQlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:41:46 -0400
Subject: [PATCH net-next] net/l2tp/l2tp_debugfs.c: Convert NIPQUAD to %pI4
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: James Chapman <jchapman@katalix.com>, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 09:41:43 -0700
Message-ID: <1271349703.1726.62.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/l2tp/l2tp_debugfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 908f10f..104ec3b 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -122,8 +122,8 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 	seq_printf(m, "\nTUNNEL %u peer %u", tunnel->tunnel_id, tunnel->peer_tunnel_id);
 	if (tunnel->sock) {
 		struct inet_sock *inet = inet_sk(tunnel->sock);
-		seq_printf(m, " from " NIPQUAD_FMT " to " NIPQUAD_FMT "\n",
-			   NIPQUAD(inet->inet_saddr), NIPQUAD(inet->inet_daddr));
+		seq_printf(m, " from %pI4 to %pI4\n",
+			   &inet->inet_saddr, &inet->inet_daddr);
 		if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
 			seq_printf(m, " source port %hu, dest port %hu\n",
 				   ntohs(inet->inet_sport), ntohs(inet->inet_dport));


