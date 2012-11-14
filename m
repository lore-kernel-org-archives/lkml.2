Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2KNFu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55038 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484Ab2KNFuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:22 -0500
Message-Id: <20121114053944.716082064@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nathan Walp <faceprint@faceprint.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 79/82] r8169: allow multicast packets on sub-8168f chipset.
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Walp <faceprint@faceprint.com>

commit 0481776b7a70f09acf7d9d97c288c3a8403fbfe4 upstream.

RTL_GIGA_MAC_VER_35 includes no multicast hardware filter.

Signed-off-by: Nathan Walp <faceprint@faceprint.com>
Suggested-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index eb6a5e4..927aa33 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4521,6 +4521,9 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		mc_filter[1] = swab32(data);
 	}
 
+	if (tp->mac_version == RTL_GIGA_MAC_VER_35)
+		mc_filter[1] = mc_filter[0] = 0xffffffff;
+
 	RTL_W32(MAR0 + 4, mc_filter[1]);
 	RTL_W32(MAR0 + 0, mc_filter[0]);
 


