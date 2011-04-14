Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab1DNRqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:37891 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1DNRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 046/209] net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
Date: Thu, 14 Apr 2011 13:41:16 -0400
Message-Id: <1302803039-9400-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 66c68bcc489fadd4f5e8839e966e3a366e50d1d5 upstream.

NETIF_F_HW_CSUM indicates the ability to update an TCP/IP-style 16-bit
checksum with the checksum of an arbitrary part of the packet data,
whereas the FCoE CRC is something entirely different.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 740e71f..f664177 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1610,10 +1610,10 @@ EXPORT_SYMBOL(netif_device_attach);
 
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
-- 
1.7.4.4

