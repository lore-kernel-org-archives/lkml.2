Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2IRIit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:38:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9474 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2IRIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:38:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 18 Sep 2012 01:38:42 -0700
From: Jim Lin <jilin@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jim Lin <jilin@nvidia.com>
Subject: [PATCH 1/1] USB: EHCI: Tegra: Fix wrong register definition
Date: Tue, 18 Sep 2012 16:42:17 +0800
Message-ID: <1347957737-14191-1-git-send-email-jilin@nvidia.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the issue that EHCI registers, hostpc[0] and usbmode_ex,
are not correctly accessed on Tegra3 platform.

Signed-off-by: Jim Lin <jilin@nvidia.com>
---
 include/linux/usb/ehci_def.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index de4b9ed..134bb4a 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -171,18 +171,18 @@ struct ehci_regs {
 #define USBMODE_CM_HC	(3<<0)		/* host controller mode */
 #define USBMODE_CM_IDLE	(0<<0)		/* idle state */
 
-	u32		reserved4[7];
+	u32		reserved4[6];
 
 /* Moorestown has some non-standard registers, partially due to the fact that
  * its EHCI controller has both TT and LPM support. HOSTPCx are extensions to
  * PORTSCx
  */
 	/* HOSTPC: offset 0x84 */
-	u32		hostpc[0];	/* HOSTPC extension */
+	u32		hostpc[1];	/* HOSTPC extension */
 #define HOSTPC_PHCD	(1<<22)		/* Phy clock disable */
 #define HOSTPC_PSPD	(3<<25)		/* Port speed detection */
 
-	u32		reserved5[17];
+	u32		reserved5[16];
 
 	/* USBMODE_EX: offset 0xc8 */
 	u32		usbmode_ex;	/* USB Device mode extension */
-- 
1.7.3

