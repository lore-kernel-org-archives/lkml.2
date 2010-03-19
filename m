Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0CSUmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:42:09 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0CSUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a0Z/gOJij/U9b+bQMFz+YomUbYIM5UnaXN+kpwk+TMI7Wpz8wWg9ekxP/0v5/5f93Z
         YJlxQJwPliJW5Gt8zlVHr2rM14x54JgSw4hB8iU/APWQBUqBRF65Yun2nuvZRectPhMY
         OPk7vbSsy24lasDv2/nZpJKUoetU5td5iU9ZA=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 6/6] staging: winbond: Convert typedef struct _SCAN_REQ_PARA to struct
Date: Sat, 20 Mar 2010 02:11:04 +0530
Message-Id: <1269031264-2327-7-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269031264-2327-6-git-send-email-sankar.curiosity@gmail.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-6-git-send-email-sankar.curiosity@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts typedef struct _SCAN_REQ_PARA to
struct scan_req_para and the places where it is used.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 drivers/staging/winbond/scan_s.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index 209717f..e677fc4 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -31,7 +31,9 @@
 
 ///////////////////////////////////////////////////////////////////////////
 //Global data structures, Initial Scan & Background Scan
-typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
+
+/* Mandatory parameters for SCAN request */
+struct scan_req_para
 {
 	u32				ScanType;			//passive/active scan
 
@@ -40,14 +42,14 @@ typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
 	struct SSID_Element	sSSID; // 34B. scan only for this SSID
 	u8			reserved_2[2];
 
-} SCAN_REQ_PARA, *psSCAN_REQ_PARA;
+};
 
 typedef struct _SCAN_PARAMETERS
 {
 	u16				wState;
 	u16				iCurrentChannelIndex;
 
-	SCAN_REQ_PARA	sScanReq;
+	struct scan_req_para	sScanReq;
 
 	u8				BSSID[MAC_ADDR_LENGTH + 2];		//scan only for this BSSID
 
-- 
1.6.4.2

