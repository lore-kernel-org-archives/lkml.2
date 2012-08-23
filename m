Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab2HWVg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:36:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:51282 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab2HWVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="190651727"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: fix max number of open handles
Date: Fri, 24 Aug 2012 00:35:58 +0300
Message-Id: <1345757758-3329-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was internal confusion in wether bus message
clinet (0) is counted in or not

The bitmap me_clients_map that accomodate
was initialized w/o it (255) but later on it
the clinet 0 was reserved

Thus were able to open only 252 instead of 253 clients

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ad6c9d5..96d3e79 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -56,19 +56,21 @@ extern const uuid_le mei_wd_guid;
 extern const u8 mei_wd_state_independence_msg[3][4];
 
 /*
+ * Number of Maximum MEI Clients
+ */
+#define MEI_CLIENTS_MAX 256
+
+/*
  * Number of File descriptors/handles
  * that can be opened to the driver.
  *
- * Limit to 253: 255 Total Clients
+ * Limit to 253: 256 Total Clients
+ * minus internal client for MEI Bus Messags
  * minus internal client for AMTHI
  * minus internal client for Watchdog
  */
-#define  MEI_MAX_OPEN_HANDLE_COUNT	253
+#define  MEI_MAX_OPEN_HANDLE_COUNT (MEI_CLIENTS_MAX - 3)
 
-/*
- * Number of Maximum MEI Clients
- */
-#define MEI_CLIENTS_MAX 255
 
 /* File state */
 enum file_state {
-- 
1.7.4.4

