Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1BBAoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:47465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1BBAoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960628"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: mmarek@suse.cz, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [69/139] l2tp: Fix modalias of l2tp_ip
Message-Id: <20110202004426.081BD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

[ Upstream commit e8d34a884e4ff118920bb57664def8a73b1b784f]

Using the SOCK_DGRAM enum results in
"net-pf-2-proto-SOCK_DGRAM-type-115", so use the numeric value like it
is done in net/dccp.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/l2tp/l2tp_ip.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/l2tp/l2tp_ip.c
===================================================================
--- linux-2.6.35.y.orig/net/l2tp/l2tp_ip.c
+++ linux-2.6.35.y/net/l2tp/l2tp_ip.c
@@ -676,4 +676,8 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP over IP");
 MODULE_VERSION("1.0");
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, SOCK_DGRAM, IPPROTO_L2TP);
+
+/* Use the value of SOCK_DGRAM (2) directory, because __stringify does't like
+ * enums
+ */
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
