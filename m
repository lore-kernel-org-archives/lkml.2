Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1KDBmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 21:42:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1KDBmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 21:42:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=WQ8p5J/gdIKyC4iZ4VdPBEKjBk4t94pz3Cusy3g8/HZqmD8ur/7mDleUAPj/HgaM6
	lSfPqPZ1EGxwf2kElY3Cg==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Sameer Nanda <snanda@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v2 2/8] forcedeth: new ethtool stat "tx_timeout" to account for tx_timeouts
Date: Thu,  3 Nov 2011 18:41:17 -0700
Message-Id: <b38a03bc1edbd129ae39b74ebb379d2354d8a45b.1320369398.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sameer Nanda <snanda@google.com>

This change publishes a new ethtool stats: tx_timeout that counts the
number of times the tx_timeout callback was triggered.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 64b1c7c..c82a3c7 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -633,6 +633,7 @@ static const struct nv_ethtool_str nv_estats_str[] = {
 	{ "rx_packets" },
 	{ "rx_errors_total" },
 	{ "tx_errors_total" },
+	{ "tx_timeout" },
 
 	/* version 2 stats */
 	{ "tx_deferral" },
@@ -673,6 +674,7 @@ struct nv_ethtool_stats {
 	u64 rx_packets;
 	u64 rx_errors_total;
 	u64 tx_errors_total;
+	u64 tx_timeout;
 
 	/* version 2 stats */
 	u64 tx_deferral;
@@ -2534,6 +2536,8 @@ static void nv_tx_timeout(struct net_device *dev)
 
 	spin_lock_irq(&np->lock);
 
+	np->estats.tx_timeout++;
+
 	/* 1) stop tx engine */
 	nv_stop_tx(dev);
 
-- 
1.7.3.1

