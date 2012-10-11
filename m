Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab2JKCPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:15:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57413 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933881Ab2JKCPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:04 -0400
X-Sasl-enc: twa2ZlIBxMLaBIjiqRiaf9JZos8zyl1B5mhFCnahKFap 1349921703
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 61/84] r8169: dont enable rx when shutdown.
Date: Thu, 11 Oct 2012 11:03:45 +0900
Message-Id: <20121011015428.063278670@linuxfoundation.org>
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

commit aaa89c08d9ffa3739c93d65d98b73ec2aa2e93a5 upstream.

Only 8111b needs to enable rx when shutdowning with WoL.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -5391,8 +5391,11 @@ static void rtl_shutdown(struct pci_dev
 	spin_unlock_irq(&tp->lock);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		/* WoL fails with some 8168 when the receiver is disabled. */
-		if (tp->features & RTL_FEATURE_WOL) {
+		/* WoL fails with 8168b when the receiver is disabled. */
+		if ((tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+		     tp->mac_version == RTL_GIGA_MAC_VER_12 ||
+		     tp->mac_version == RTL_GIGA_MAC_VER_17) &&
+		    (tp->features & RTL_FEATURE_WOL)) {
 			pci_clear_master(pdev);
 
 			RTL_W8(ChipCmd, CmdRxEnb);


