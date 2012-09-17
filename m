Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2IQBE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:04:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33789 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab2IQAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:05 -0400
Message-Id: <20120917003634.277846583@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 058/135] atm: fix info leak via getsockname()
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

[ Upstream commit 3c0c5cfdcd4d69ffc4b9c0907cec99039f30a50a ]

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/atm/pvc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/atm/pvc.c b/net/atm/pvc.c
index 3a73491..ae03240 100644
--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -95,6 +95,7 @@ static int pvc_getname(struct socket *sock, struct sockaddr *sockaddr,
 		return -ENOTCONN;
 	*sockaddr_len = sizeof(struct sockaddr_atmpvc);
 	addr = (struct sockaddr_atmpvc *)sockaddr;
+	memset(addr, 0, sizeof(*addr));
 	addr->sap_family = AF_ATMPVC;
 	addr->sap_addr.itf = vcc->dev->number;
 	addr->sap_addr.vpi = vcc->vpi;


