Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2ISDpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:45:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4283 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2ISDpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:45:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Sep 2012 20:45:06 -0700
From: Jim Lin <jilin@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jim Lin <jilin@nvidia.com>
Subject: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
Date: Wed, 19 Sep 2012 11:48:50 +0800
Message-ID: <1348026530-17327-1-git-send-email-jilin@nvidia.com>
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
Changes in v2:
- Modify array size for reserved4[] only.
- Note that defining hostpc[0] is for a variable-length object.
 
 include/linux/usb/ehci_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index de4b9ed..b3c9d1b 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -171,7 +171,7 @@ struct ehci_regs {
 #define USBMODE_CM_HC	(3<<0)		/* host controller mode */
 #define USBMODE_CM_IDLE	(0<<0)		/* idle state */
 
-	u32		reserved4[7];
+	u32		reserved4[6];
 
 /* Moorestown has some non-standard registers, partially due to the fact that
  * its EHCI controller has both TT and LPM support. HOSTPCx are extensions to
-- 
1.7.3

