Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1ERVJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:09:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41243 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1ERVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:09:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:organization;
	b=eZqeBE//huAZZXntyLeQxKARdRnS6wA555F5hSQMkUVCS7Sg0PFUmn1uKbmuGCJWO
	pr9jVicbVKTGQuo2nyhxw==
From: David Decotigny <decot@google.com>
To: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel-net-upstream@google.com, Sameer Nanda <snanda@google.com>,
        David Decotigny <decot@google.com>
Subject: [PATCH] forcedeth: new ethtool stat "tx_timeout" to account for tx_timeouts
Date: Wed, 18 May 2011 14:09:05 -0700
Message-Id: <1305752945-14843-2-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305752945-14843-1-git-send-email-decot@google.com>
References: <1305752945-14843-1-git-send-email-decot@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sameer Nanda <snanda@google.com>

This change publishes a new ethtool stats: tx_timeout that counts the
number of times the tx_timeout callback was triggered.


Signed-off-by: David Decotigny <decot@google.com>
---
 drivers/net/forcedeth.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 895471d..112dc0b 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -632,6 +632,7 @@ static const struct nv_ethtool_str nv_estats_str[] = {
 	{ "rx_packets" },
 	{ "rx_errors_total" },
 	{ "tx_errors_total" },
+	{ "tx_timeout" },
 
 	/* version 2 stats */
 	{ "tx_deferral" },
@@ -672,6 +673,7 @@ struct nv_ethtool_stats {
 	u64 rx_packets;
 	u64 rx_errors_total;
 	u64 tx_errors_total;
+	u64 tx_timeout;
 
 	/* version 2 stats */
 	u64 tx_deferral;
@@ -2526,6 +2528,8 @@ static void nv_tx_timeout(struct net_device *dev)
 
 	spin_lock_irq(&np->lock);
 
+	np->estats.tx_timeout++;
+
 	/* 1) stop tx engine */
 	nv_stop_tx(dev);
 
-- 
1.7.3.1

