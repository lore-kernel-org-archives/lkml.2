Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2KVV5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:57:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:49605 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab2KVSkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nathan Walp <faceprint@faceprint.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 69/83] r8169: allow multicast packets on sub-8168f chipset.
Date: Wed, 21 Nov 2012 16:42:31 -0800
Message-Id: <20121122004220.102634235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Walp <faceprint@faceprint.com>

commit 0481776b7a70f09acf7d9d97c288c3a8403fbfe4 upstream.

RTL_GIGA_MAC_VER_35 includes no multicast hardware filter.

Signed-off-by: Nathan Walp <faceprint@faceprint.com>
Suggested-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4526,6 +4526,9 @@ static void rtl_set_rx_mode(struct net_d
 		mc_filter[1] = swab32(data);
 	}
 
+	if (tp->mac_version == RTL_GIGA_MAC_VER_35)
+		mc_filter[1] = mc_filter[0] = 0xffffffff;
+
 	RTL_W32(MAR0 + 4, mc_filter[1]);
 	RTL_W32(MAR0 + 0, mc_filter[0]);
 


