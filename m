Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0LHCPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:15:16 -0500
Received: from kroah.org ([198.145.64.141]:46008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab0LHAq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:58 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:27 2010
Message-Id: <20101208004427.632031744@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [033/127] net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 66c68bcc489fadd4f5e8839e966e3a366e50d1d5 upstream.

NETIF_F_HW_CSUM indicates the ability to update an TCP/IP-style 16-bit
checksum with the checksum of an arbitrary part of the packet data,
whereas the FCoE CRC is something entirely different.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1484,10 +1484,10 @@ EXPORT_SYMBOL(netif_device_attach);
 
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


