Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2LBCyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:54:53 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45796 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2LBCyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:54:52 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2012 21:54:51 EST
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        tvboxspy@gmail.com, marcos.souza.org@gmail.com, standby24x7@gmail.com,
        justinmattock@gmail.com, devel@driverdev.osuosl.org
Subject: [PATCH 6/6] vt6656: remove a useless call to memset().
Date: Sun,  2 Dec 2012 03:40:22 +0100
Message-Id: <1354416022-20189-7-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call is followed by a call to memcpy() on the same memory area, so it can
be safely removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 6a13941..f9098b8 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -240,7 +240,6 @@ pDevice->bSameBSSMaxNum = jj;
             pSelect->bSelected = TRUE;
                         if (pDevice->bRoaming == FALSE)  {
 	//       Einsn Add @20070907
-				memset(pbyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			memcpy(pbyDesireSSID,pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
                                                 }
 
-- 
1.7.10.4

