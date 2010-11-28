Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0K1VB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:01:28 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37404 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0K1VAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:13 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 09/13] w35und: Kill _IBSS_BEACON_SEQ_STICK_
Date: Sun, 28 Nov 2010 23:00:04 +0200
Message-Id: <1290978008-29095-9-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills the _IBSS_BEACON_SEQ_STICK_ ifdefs because the macro is never
defined.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mlmetxrx_f.h |    4 ----
 drivers/staging/winbond/reg.c        |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index 012507f..6db423b 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -16,8 +16,4 @@ void
 MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
 		  unsigned char SendOK);
 
-#ifdef _IBSS_BEACON_SEQ_STICK_
-s8 SendBCNullData(struct wbsoft_priv *adapter, u16 wIdx);
-#endif
-
 #endif
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 4d2c6a1..1b38d6d 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -2064,11 +2064,7 @@ void Mxx_initial(struct hw_data *pHwData)
 	 */
 
 	/* M00 bit set */
-	#ifdef _IBSS_BEACON_SEQ_STICK_
-	reg->M00_MacControl = 0; /* Solve beacon sequence number stop by software */
-	#else
 	reg->M00_MacControl = 0x80000000; /* Solve beacon sequence number stop by hardware */
-	#endif
 
 	/* M24 disable enter power save, BB RxOn and enable NAV attack */
 	reg->M24_MacControl = 0x08040042;
-- 
1.7.0.4

