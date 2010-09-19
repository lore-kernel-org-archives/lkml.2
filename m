Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0ISJ2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:28:49 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55877 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0ISJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:46 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 3/7] w35und: Kill unused scan_s.h header
Date: Sun, 19 Sep 2010 12:28:39 +0300
Message-Id: <1284888523-9625-3-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284888523-9625-2-git-send-email-penberg@kernel.org>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
 <1284888523-9625-2-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scan_s.h header is not actually used for anything so just kill it off.

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds_s.h  |    1 -
 drivers/staging/winbond/scan_s.h |   57 --------------------------------------
 2 files changed, 0 insertions(+), 58 deletions(-)
 delete mode 100644 drivers/staging/winbond/scan_s.h

diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index 89328c5..e2de4bd 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -7,7 +7,6 @@
 
 #include "localpara.h"
 #include "mac_structures.h"
-#include "scan_s.h"
 
 /* Preamble_Type, see <SFS-802.11G-MIB-203> */
 enum {
diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
deleted file mode 100644
index 85cdf3b..0000000
--- a/drivers/staging/winbond/scan_s.h
+++ /dev/null
@@ -1,57 +0,0 @@
-#ifndef __WINBOND_SCAN_S_H
-#define __WINBOND_SCAN_S_H
-
-#include <linux/types.h>
-#include "localpara.h"
-
-/*
- * SCAN task global CONSTANTS, STRUCTURES, variables
- */
-
-/* define the msg type of SCAN module */
-#define SCANMSG_SCAN_REQ		0x01
-#define SCANMSG_BEACON			0x02
-#define SCANMSG_PROBE_RESPONSE		0x03
-#define SCANMSG_TIMEOUT			0x04
-#define SCANMSG_TXPROBE_FAIL		0x05
-#define SCANMSG_ENABLE_BGSCAN		0x06
-#define SCANMSG_STOP_SCAN		0x07
-
-/*
- * BSS Type =>conform to
- * IBSS             : ToDS/FromDS = 00
- * Infrastructure   : ToDS/FromDS = 01
- */
-#define IBSS_NET			0
-#define ESS_NET				1
-#define ANYBSS_NET			2
-
-/* Scan Type */
-#define ACTIVE_SCAN			0
-#define PASSIVE_SCAN			1
-
-/*
- * ===========================================================
- *	scan.h
- *		Define the related definitions of scan module
- *
- * ===========================================================
- */
-
-/* Define the state of scan module */
-#define SCAN_INACTIVE			0
-#define WAIT_PROBE_DELAY		1
-#define WAIT_RESPONSE_MIN		2
-#define WAIT_RESPONSE_MAX_ACTIVE	3
-#define WAIT_BEACON_MAX_PASSIVE		4
-#define SCAN_COMPLETE			5
-#define BG_SCAN				6
-#define BG_SCANNING			7
-
-
-/*
- * The value will load from EEPROM
- * If 0xff is set in EEPOM, the driver will use SCAN_MAX_CHNL_TIME instead.
- * The definition is in WbHal.h
- */
-#endif
-- 
1.6.3.3

