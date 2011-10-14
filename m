Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1JNUf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:35:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:59311 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab1JNUfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:35:25 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-usb@vger.kernel.org, Xu lei <B33228@freescale.com>
Subject: [PATCH] USB: Fix USB Kconfig dependency problem on 85xx/QoirQ platforms
Date: Fri, 14 Oct 2011 15:35:10 -0500
Message-Id: <1318624510-24058-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xu lei <B33228@freescale.com>

For FSL PPC SoCs USB_ARCH_HAS_EHCI currently on depends on PPC_83xx.
However that excludes support for USB on 85xx & QorIQ devices.  Use
FSL_SOC insted which will get us 83xx, 85xx, QorIQ, and 5xxx which all
have the same USB IP on them.

Signed-off-by: Xulei <B33228@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/usb/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 48f1781..1580d7c 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -54,7 +54,7 @@ config USB_ARCH_HAS_OHCI
 # some non-PCI hcds implement EHCI
 config USB_ARCH_HAS_EHCI
 	boolean
-	default y if PPC_83xx
+	default y if FSL_SOC
 	default y if PPC_MPC512x
 	default y if SOC_AU1200
 	default y if ARCH_IXP4XX
-- 
1.7.3.4

