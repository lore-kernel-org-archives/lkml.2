Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994Ab2JKCQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:16:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48211 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964875Ab2JKCQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:16:10 -0400
X-Sasl-enc: 77Zz7j8CcIEwlR2qCdKXk6ek5lcbDJ/PWtGB5QmWuvkK 1349921769
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/84] r8169: fix wake on lan setting for non-8111E.
Date: Thu, 11 Oct 2012 11:03:44 +0900
Message-Id: <20121011015427.889586553@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hayes Wang <hayeswang@realtek.com>

commit d4ed95d796e5126bba51466dc07e287cebc8bd19 upstream.

Only 8111E needs enable RxConfig bit 0 ~ 3 when suspending or
shutdowning for wake on lan.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3126,8 +3126,10 @@ static void r8168_pll_power_down(struct
 		rtl_writephy(tp, 0x1f, 0x0000);
 		rtl_writephy(tp, MII_BMCR, 0x0000);
 
-		RTL_W32(RxConfig, RTL_R32(RxConfig) |
-			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_33)
+			RTL_W32(RxConfig, RTL_R32(RxConfig) | AcceptBroadcast |
+				AcceptMulticast | AcceptMyPhys);
 		return;
 	}
 


