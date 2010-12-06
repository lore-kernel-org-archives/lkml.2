Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0LFMjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:39:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0LFMja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:39:30 -0500
From: Michal Marek <mmarek@suse.cz>
To: James Chapman <jchapman@katalix.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] l2tp: Fix modalias of l2tp_ip
Date: Mon,  6 Dec 2010 13:39:12 +0100
Message-Id: <1291639152-26608-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the SOCK_DGRAM enum results in
"net-pf-2-proto-SOCK_DGRAM-type-115", so use the numeric value like it
is done in net/dccp.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 net/l2tp/l2tp_ip.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 0bf6a59..522e219 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -674,4 +674,8 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP over IP");
 MODULE_VERSION("1.0");
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, SOCK_DGRAM, IPPROTO_L2TP);
+
+/* Use the value of SOCK_DGRAM (2) directory, because __stringify does't like
+ * enums
+ */
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
-- 
1.7.3.1

