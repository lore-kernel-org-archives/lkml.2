Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0K1VAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:00:18 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39959 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0K1VAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:11 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 07/13] w35und: Kill Vendor2 ifdef from hal_init_hardware
Date: Sun, 28 Nov 2010 23:00:02 +0200
Message-Id: <1290978008-29095-7-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Vendor2 macro is never defined so remove the ifdef'd block from
hal_init_hardware().

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/wbusb.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 5f54b0f..9fc078f 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -642,13 +642,6 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 
 	SoftwareSet = hal_software_set(pHwData);
 
-#ifdef Vendor2
-	/* Try to make sure the EEPROM contain */
-	SoftwareSet >>= 8;
-	if (SoftwareSet != 0x82)
-		return false;
-#endif
-
 	Wb35Rx_start(hw);
 	Wb35Tx_EP2VM_start(priv);
 
-- 
1.7.0.4

