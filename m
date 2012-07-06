Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab2GFP2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:28:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:43256 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab2GFP2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174187153"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 5/6] staging: vt6656: use %pM for the BSSID
Date: Fri,  6 Jul 2012 18:28:17 +0300
Message-Id: <1341588498-21689-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 619c257..0999367 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -129,9 +129,8 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
     unsigned int ii = 0;
     unsigned int jj = 0;
     if (pbyDesireBSSID != NULL) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSpSearchBSSList BSSID[%02X %02X %02X-%02X %02X %02X]\n",
-                            *pbyDesireBSSID,*(pbyDesireBSSID+1),*(pbyDesireBSSID+2),
-                            *(pbyDesireBSSID+3),*(pbyDesireBSSID+4),*(pbyDesireBSSID+5));
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 	if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
 	     (memcmp(pbyDesireBSSID, ZeroBSSID, 6)!= 0)){
             pbyBSSID = pbyDesireBSSID;
@@ -218,7 +217,9 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
                 }
 
         pMgmt->pSameBSS[jj].uChannel = pCurrBSS->uChannel;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSpSearchBSSList pSelect1[%02X %02X %02X-%02X %02X %02X]\n",*pCurrBSS->abyBSSID,*(pCurrBSS->abyBSSID+1),*(pCurrBSS->abyBSSID+2),*(pCurrBSS->abyBSSID+3),*(pCurrBSS->abyBSSID+4),*(pCurrBSS->abyBSSID+5));
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"BSSpSearchBSSList pSelect1[%pM]\n",
+			pCurrBSS->abyBSSID);
         jj++;
 
 
-- 
1.7.10.4

