Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0LLXq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35966 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0LLXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:24 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: bhutchings@solarflare.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [84/223] net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
Message-Id: <20101212234623.93332B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ben Hutchings <bhutchings@solarflare.com>

commit 66c68bcc489fadd4f5e8839e966e3a366e50d1d5 upstream.

NETIF_F_HW_CSUM indicates the ability to update an TCP/IP-style 16-bit
checksum with the checksum of an arbitrary part of the packet data,
whereas the FCoE CRC is something entirely different.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/core/dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/net/core/dev.c
===================================================================
--- linux.orig/net/core/dev.c
+++ linux/net/core/dev.c
@@ -1653,10 +1653,10 @@ EXPORT_SYMBOL(netif_device_attach);
 
 static bool can_checksum_protocol(unsigned long features, __be16 protocol)
 {
-	return ((features & NETIF_F_GEN_CSUM) ||
-		((features & NETIF_F_IP_CSUM) &&
+	return ((features & NETIF_F_NO_CSUM) ||
+		((features & NETIF_F_V4_CSUM) &&
 		 protocol == htons(ETH_P_IP)) ||
-		((features & NETIF_F_IPV6_CSUM) &&
+		((features & NETIF_F_V6_CSUM) &&
 		 protocol == htons(ETH_P_IPV6)) ||
 		((features & NETIF_F_FCOE_CRC) &&
 		 protocol == htons(ETH_P_FCOE)));
