Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1AFAaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:06 -0500
Received: from kroah.org ([198.145.64.141]:35780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab1AFAaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:04 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.444859063@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [072/152] l2tp: Fix modalias of l2tp_ip
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Michal Marek <mmarek@suse.cz>

[ Upstream commit 3e5653f0bc5150a2cc67b707130344ce05fb440e ]

Using the SOCK_DGRAM enum results in
"net-pf-2-proto-SOCK_DGRAM-type-115", so use the numeric value like it
is done in net/dccp.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/l2tp/l2tp_ip.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
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


