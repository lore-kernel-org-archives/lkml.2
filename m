Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1GFIAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:00:07 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45961 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1GFH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:58:50 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p667wiYf003443
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 7/7] r8169: don't enable rx when shutdown
Date: Wed, 6 Jul 2011 15:58:08 +0800
X-BOX-Message-Id: p667wiYf003443
Message-ID: <1309939088-31994-7-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1309939088-31994-1-git-send-email-hayeswang@realtek.com>
References: <1309939088-31994-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only 8111b needs to enable rx when shutdown for supporting WOL.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/r8169.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 8551848..99a2f30 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -5760,8 +5760,11 @@ static void rtl_shutdown(struct pci_dev *pdev)
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
-- 
1.7.3.2

