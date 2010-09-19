Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0ISJ3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:29:37 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58083 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0ISJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:46 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 4/7] w35und: Remove dead code from mlme_s.h
Date: Sun, 19 Sep 2010 12:28:40 +0300
Message-Id: <1284888523-9625-4-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284888523-9625-3-git-send-email-penberg@kernel.org>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
 <1284888523-9625-2-git-send-email-penberg@kernel.org>
 <1284888523-9625-3-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's bunch of macros in mlme_s.h that aren't used for anything. Kill them
off.

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mlme_s.h |  116 --------------------------------------
 1 files changed, 0 insertions(+), 116 deletions(-)

diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index d5b6364..0e7d2f6 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -8,112 +8,6 @@
 #include "mds_s.h"
 
 /*
- * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- *	Mlme.h
- *		Define the related definitions of MLME module
- *
- * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- */
-
-#define AUTH_REJECT_REASON_CHALLENGE_FAIL	1
-
-/* the state of MLME module */
-#define INACTIVE		0x0
-#define IDLE_SCAN		0x1
-
-/* the state of MLME/ESS module */
-#define STATE_1			0x2
-#define AUTH_REQ		0x3
-#define AUTH_WEP		0x4
-#define STATE_2			0x5
-#define ASSOC_REQ		0x6
-#define STATE_3			0x7
-
-/* the state of MLME/IBSS module */
-#define IBSS_JOIN_SYNC		0x8
-#define IBSS_AUTH_REQ		0x9
-#define IBSS_AUTH_CHANLGE	0xa
-#define IBSS_AUTH_WEP		0xb
-#define IBSS_AUTH_IND		0xc
-#define IBSS_STATE_2		0xd
-
-
-
-/*
- * =========================================
- * depend on D5C(MAC timing control 03 register):
- * MaxTxMSDULifeTime default 0x80000us
- */
-#define AUTH_FAIL_TIMEOUT	550
-#define ASSOC_FAIL_TIMEOUT	550
-#define REASSOC_FAIL_TIMEOUT	550
-
-/* MLME task global CONSTANTS, STRUCTURE, variables */
-
-/* =========================================
- * enum_ResultCode --
- * Result code returned from MLME to SME.
- * =========================================
- */
-#define MLME_SUCCESS			0	/* follow spec. */
-#define	INVALID_PARAMETERS		1	/* Not following spec. */
-#define	NOT_SUPPPORTED			2
-#define	TIMEOUT				3
-#define	TOO_MANY_SIMULTANEOUS_REQUESTS	4
-#define REFUSED				5
-#define	BSS_ALREADY_STARTED_OR_JOINED	6
-#define	TRANSMIT_FRAME_FAIL		7
-#define	NO_BSS_FOUND			8
-#define RETRY				9
-#define GIVE_UP				10
-
-
-#define OPEN_AUTH			0
-#define SHARE_AUTH			1
-#define ANY_AUTH			2
-#define WPA_AUTH			3	/* for WPA */
-#define WPAPSK_AUTH			4
-#define WPANONE_AUTH			5
-#ifdef _WPA2_
-#define WPA2_AUTH			6	/* for WPA2 */
-#define WPA2PSK_AUTH			7
-#endif /* end def _WPA2_ */
-
-/*
- * =========================================
- * define the msg type of MLME module
- * =========================================
- */
-
-/* from SME */
-#define MLMEMSG_AUTH_REQ		0x0b
-#define MLMEMSG_DEAUTH_REQ		0x0c
-#define MLMEMSG_ASSOC_REQ		0x0d
-#define MLMEMSG_REASSOC_REQ		0x0e
-#define MLMEMSG_DISASSOC_REQ		0x0f
-#define MLMEMSG_START_IBSS_REQ		0x10
-#define MLMEMSG_IBSS_NET_CFM		0x11
-
-/* from RX */
-#define MLMEMSG_RCV_MLMEFRAME		0x20
-#define MLMEMSG_RCV_ASSOCRSP		0x22
-#define MLMEMSG_RCV_REASSOCRSP		0x24
-#define MLMEMSG_RCV_DISASSOC		0x2b
-#define MLMEMSG_RCV_AUTH		0x2c
-#define MLMEMSG_RCV_DEAUTH		0x2d
-
-
-/* from TX callback */
-#define MLMEMSG_TX_CALLBACK		0x40
-#define MLMEMSG_ASSOCREQ_CALLBACK	0x41
-#define MLMEMSG_REASSOCREQ_CALLBACK	0x43
-#define MLMEMSG_DISASSOC_CALLBACK	0x4a
-#define MLMEMSG_AUTH_CALLBACK		0x4c
-#define MLMEMSG_DEAUTH_CALLBACK		0x4d
-
-#define MLMEMSG_TIMEOUT			0x50
-
-/*
  * ==============================================
  * Global data structures
  * ==============================================
@@ -122,16 +16,6 @@
 #define MAX_MMPDU_SIZE			1512
 #define MAX_NUM_RX_MMPDU		6
 
-
-/*
- * ==============================================
- * MACRO
- * ==============================================
- */
-#define boMLME_InactiveState(_AA_)	(_AA_->wState == INACTIVE)
-#define boMLME_IdleScanState(_BB_)	(_BB_->wState == IDLE_SCAN)
-#define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState >= IDLE_SCAN)
-
 struct mlme_frame {
 	s8		*pMMPDU;
 	u16		len;
-- 
1.6.3.3

