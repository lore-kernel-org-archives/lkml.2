Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0CTToE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:44:04 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:36413 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0CTToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:44:01 -0400
X-SENDER-IP: [83.226.250.190]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlE0AF7CpEtT4vq+PGdsb2JhbACHXpNeDAEBAQE3La5OjUSEfQQ
X-IronPort-AV: E=Sophos;i="4.51,279,1267398000"; 
   d="scan'208";a="53666522"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: scan_s.h Coding style fixes.
Date: Sat, 20 Mar 2010 20:43:59 +0100
Message-Id: <1269114239-4007-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed all things reported by checkpatch.pl except a couple
of long lines and typedefs.
I also removed "commented away" code and a history comment.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/scan_s.h |  152 ++++++++++++++++++--------------------
 1 files changed, 71 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index 209717f..85e7523 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -4,117 +4,107 @@
 #include <linux/types.h>
 #include "localpara.h"
 
-//
-// SCAN task global CONSTANTS, STRUCTURES, variables
-//
-
-//////////////////////////////////////////////////////////////////////////
-//define the msg type of SCAN module
-#define SCANMSG_SCAN_REQ			0x01
-#define SCANMSG_BEACON				0x02
+/*
+ * SCAN task global CONSTANTS, STRUCTURES, variables
+ */
+
+/* define the msg type of SCAN module */
+#define SCANMSG_SCAN_REQ		0x01
+#define SCANMSG_BEACON			0x02
 #define SCANMSG_PROBE_RESPONSE		0x03
-#define SCANMSG_TIMEOUT				0x04
+#define SCANMSG_TIMEOUT			0x04
 #define SCANMSG_TXPROBE_FAIL		0x05
 #define SCANMSG_ENABLE_BGSCAN		0x06
-#define SCANMSG_STOP_SCAN			0x07
+#define SCANMSG_STOP_SCAN		0x07
 
-// BSS Type =>conform to
-// IBSS             : ToDS/FromDS = 00
-// Infrastructure   : ToDS/FromDS = 01
+/*
+ * BSS Type =>conform to
+ * IBSS             : ToDS/FromDS = 00
+ * Infrastructure   : ToDS/FromDS = 01
+ */
 #define IBSS_NET			0
 #define ESS_NET				1
 #define ANYBSS_NET			2
 
-// Scan Type
+/* Scan Type */
 #define ACTIVE_SCAN			0
-#define PASSIVE_SCAN		1
+#define PASSIVE_SCAN			1
+
+/* Global data structures, Initial Scan & Background Scan */
+typedef struct _SCAN_REQ_PARA {	/* mandatory parameters for SCAN request */
 
-///////////////////////////////////////////////////////////////////////////
-//Global data structures, Initial Scan & Background Scan
-typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
-{
-	u32				ScanType;			//passive/active scan
+	u32			ScanType;	/* passive/active scan */
 
 	u8			reserved_1[2];
 
-	struct SSID_Element	sSSID; // 34B. scan only for this SSID
+	struct SSID_Element	sSSID; /* 34B. scan only for this SSID */
 	u8			reserved_2[2];
 
 } SCAN_REQ_PARA, *psSCAN_REQ_PARA;
 
-typedef struct _SCAN_PARAMETERS
-{
-	u16				wState;
-	u16				iCurrentChannelIndex;
+typedef struct _SCAN_PARAMETERS {
+	u16		wState;
+	u16		iCurrentChannelIndex;
 
 	SCAN_REQ_PARA	sScanReq;
 
-	u8				BSSID[MAC_ADDR_LENGTH + 2];		//scan only for this BSSID
+	u8		BSSID[MAC_ADDR_LENGTH + 2]; /* scan only for this BSSID */
 
-	u32				BssType;						//scan only for this BSS type
+	u32		BssType;	/* scan only for this BSS type */
 
-	//struct SSID_Element	sSSID;						//scan only for this SSID
-	u16				ProbeDelay;
-	u16				MinChannelTime;
+	u16		ProbeDelay;
+	u16		MinChannelTime;
 
-	u16				MaxChannelTime;
-	u16				reserved_1;
+	u16		MaxChannelTime;
+	u16		reserved_1;
 
-    s32				iBgScanPeriod;				// XP: 5 sec
+	s32		iBgScanPeriod;	/* XP: 5 sec */
 
-    u8				boBgScan;					// Wb: enable BG scan, For XP, this value must be FALSE
-    u8				boFastScan;					// Wb: reserved
-	u8				boCCAbusy;					// Wb: HWMAC CCA busy status
-	u8				reserved_2;
+	u8		boBgScan;	/* Wb: enable BG scan, For XP, this value must be FALSE */
+	u8		boFastScan;	/* Wb: reserved */
+	u8		boCCAbusy;	/* Wb: HWMAC CCA busy status */
+	u8		reserved_2;
 
 	struct timer_list timer;
 
-	u32				ScanTimeStamp;			//Increase 1 per background scan(1 minute)
-	u32				BssTimeStamp;			//Increase 1 per connect status check
-	u32				RxNumPerAntenna[2];		//
-
-	u8				AntennaToggle;			//
-	u8				boInTimerHandler;
-	u8 				boTimerActive;				// Wb: reserved
-	u8				boSave;
+	u32		ScanTimeStamp;	/* Increase 1 per background scan(1 minute) */
+	u32		BssTimeStamp;	/* Increase 1 per connect status check */
+	u32		RxNumPerAntenna[2];
 
-	u32				BScanEnable; // Background scan enable. Default is On
+	u8		AntennaToggle;
+	u8		boInTimerHandler;
+	u8		boTimerActive;	/* Wb: reserved */
+	u8		boSave;
 
+	u32		BScanEnable; /* Background scan enable. Default is On */
 } SCAN_PARAMETERS, *psSCAN_PARAMETERS;
 
-// Encapsulate 'adapter' data structure
-#define psSCAN			(&(adapter->sScanPara))
-#define psSCANREQ			(&(adapter->sScanPara.sScanReq))
-
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	scan.h
-//		Define the related definitions of scan module
-//	history -- 01/14/03' created
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
-//Define the state of scan module
-#define SCAN_INACTIVE						0
-#define WAIT_PROBE_DELAY					1
-#define WAIT_RESPONSE_MIN					2
-#define WAIT_RESPONSE_MAX_ACTIVE			3
-#define WAIT_BEACON_MAX_PASSIVE				4
-#define SCAN_COMPLETE						5
-#define BG_SCAN								6
-#define BG_SCANNING							7
-
-
-// The value will load from EEPROM
-// If 0xff is set in EEPOM, the driver will use SCAN_MAX_CHNL_TIME instead.
-// The definition is in WbHal.h
-//	#define SCAN_MAX_CHNL_TIME				(50)
-
-
-
-// static functions
-
-//static void ScanTimerHandler(struct wbsoft_priv * adapter);
-//static void vScanTimerStart(struct wbsoft_priv *	adapter, int timeout_value);
-//static void vScanTimerStop(struct wbsoft_priv * adapter);
-
+/* Encapsulate 'adapter' data structure */
+#define psSCAN		(&(adapter->sScanPara))
+#define psSCANREQ	(&(adapter->sScanPara.sScanReq))
+
+/*
+ * ===========================================================
+ *	scan.h
+ *		Define the related definitions of scan module
+ *
+ * ===========================================================
+ */
+
+/* Define the state of scan module */
+#define SCAN_INACTIVE			0
+#define WAIT_PROBE_DELAY		1
+#define WAIT_RESPONSE_MIN		2
+#define WAIT_RESPONSE_MAX_ACTIVE	3
+#define WAIT_BEACON_MAX_PASSIVE		4
+#define SCAN_COMPLETE			5
+#define BG_SCAN				6
+#define BG_SCANNING			7
+
+
+/*
+ * The value will load from EEPROM
+ * If 0xff is set in EEPOM, the driver will use SCAN_MAX_CHNL_TIME instead.
+ * The definition is in WbHal.h
+ */
 #endif
-- 
1.7.0.2

