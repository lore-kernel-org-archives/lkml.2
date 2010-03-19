Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0CSUmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:42:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0CSUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V/rAZwiVyvAZlBSqQetGo7WGI1ccG0Mp4yZyxvNTzit+ZYu03J9SFzIxl+05r+s2b9
         Bq2ZvMCjurOd68/u784CZPeAXhtD990NvX7rdMCJlbFTC/xpinJ3YOP0fpp0gW3cihSM
         5IzFwvEYdF9ULQ9JVQHfcBXQ5xXguts9qtJTY=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 5/6] staging: winbond: Convert typedef struct _MLME_FRAME to struct
Date: Sat, 20 Mar 2010 02:11:03 +0530
Message-Id: <1269031264-2327-6-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the typedef struct _MLME_FRAME to
struct mlme_frame and updates the places where it is used.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 drivers/staging/winbond/core.h   |    2 +-
 drivers/staging/winbond/mlme_s.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 0a2060b..372053a 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -16,7 +16,7 @@ struct wbsoft_priv {
 
 	struct wb_local_para sLocalPara;	// Myself connected parameters
 
-	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
+	struct mlme_frame sMlmeFrame;	/* connect to peerSTA parameters */
 
 	struct wb35_mto_params sMtoPara;	// MTO_struct ...
 	struct hw_data sHwData;	//For HAL
diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index 1217a1c..c95debf 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -131,7 +131,7 @@
 #define boMLME_IdleScanState(_BB_)	(_BB_->wState==IDLE_SCAN)
 #define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState>=IDLE_SCAN)
 
-typedef struct _MLME_FRAME
+struct mlme_frame
 {
 	//NDIS_PACKET		MLME_Packet;
 	s8 *			pMMPDU;
@@ -156,7 +156,7 @@ typedef struct _MLME_FRAME
 	u16		wNumRxMMPDUInMLME; 	// Number of the Rx MMPDU
 	u16		reserved_1;			//  in MLME.
                     	            //  excluding the discarded
-} MLME_FRAME, *psMLME_FRAME;
+};
 
 typedef struct _AUTHREQ {
 
-- 
1.6.4.2

