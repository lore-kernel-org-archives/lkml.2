Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2IQBDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:03:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33791 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304Ab2IQAvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:06 -0400
Message-Id: <20120917003634.120264258@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 057/135] atm: fix info leak in getsockopt(SO_ATMPVC)
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e862f1a9b7df4e8196ebec45ac62295138aa3fc2 ]

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/atm/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/atm/common.c b/net/atm/common.c
index 14ff9fe..0ca06e8 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -784,6 +784,7 @@ int vcc_getsockopt(struct socket *sock, int level, int optname,
 
 		if (!vcc->dev || !test_bit(ATM_VF_ADDR, &vcc->flags))
 			return -ENOTCONN;
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = vcc->dev->number;
 		pvc.sap_addr.vpi = vcc->vpi;


