Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0K1VBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:01:04 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39980 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0K1VAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:15 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 08/13] w35und: Kill write-only ->TxToggle
Date: Sun, 28 Nov 2010 23:00:03 +0200
Message-Id: <1290978008-29095-8-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes ->TxToggle from struct wb35_mds because it's a write only struct member.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds.c   |    5 -----
 drivers/staging/winbond/mds_s.h |    4 ----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index b4e0514..0daabdc 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -481,11 +481,6 @@ Mds_Tx(struct wbsoft_priv *adapter)
 			XmitBufSize += CurrentSize;
 			XmitBufAddress += CurrentSize;
 
-#ifdef _IBSS_BEACON_SEQ_STICK_
-			if ((XmitBufAddress[DOT_11_DA_OFFSET+8] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) /* +8 for USB hdr */
-#endif
-				pMds->TxToggle = true;
-
 			/* Get packet to transmit completed, 1:TESTSTA 2:MLME 3: Ndis data */
 			MLME_SendComplete(adapter, 0, true);
 
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index e2de4bd..eeedf01 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -107,10 +107,6 @@ struct wb35_mds {
 	u8	TxRate[((MAX_USB_TX_DESCRIPTOR + 1) & ~0x01)][2]; /* [0] current tx rate, [1] fall back rate */
 	u8	TxInfo[((MAX_USB_TX_DESCRIPTOR + 1) & ~0x01)]; /*Store information for callback function */
 
-	/* for scanning mechanism */
-	u8	TxToggle;	/* It is TRUE if there are tx activities in some time interval */
-	u8	Reserved_[3];
-
 	/* ---- for Tx Parameter */
 	u16	TxFragmentThreshold;	/* For frame body only */
 	u16	TxRTSThreshold;
-- 
1.7.0.4

