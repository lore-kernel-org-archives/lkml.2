Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1EPT3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:29:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52531 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab1EPT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:29:08 -0400
Subject: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 12:28:48 -0700
Message-ID: <1305574128.3456.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/linux/netdevice.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a134d80..2646251 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1066,6 +1066,16 @@ struct net_device {
 #define NETIF_F_NOCACHE_COPY	(1 << 30) /* Use no-cache copyfromuser */
 #define NETIF_F_LOOPBACK	(1 << 31) /* Enable loopback */
 
+/*
+ * Bit 31 is for device to map userspace buffers -- zerocopy
+ * Device can set this flag when it supports HIGHDMA.
+ * Device can't recycle this kind of skb buffers.
+ * There are 256 bytes copied, the rest of buffers are mapped.
+ * The userspace callback should only be called when last reference to this skb
+ * is gone.
+ */
+#define NETIF_F_ZEROCOPY	(1 << 31)
+
 	/* Segmentation offload features */
 #define NETIF_F_GSO_SHIFT	16
 #define NETIF_F_GSO_MASK	0x00ff0000


