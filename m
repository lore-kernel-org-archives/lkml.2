Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2GJL7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:59:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:34449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2GJL7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:59:05 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linuxppc-dev@ozlabs.org, linux-usb@vger.kernel.org,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: ehci-fsl: Update ifdef check to work on 64-bit ppc
Date: Tue, 10 Jul 2012 06:58:48 -0500
Message-Id: <1341921528-21630-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use CONFIG_FSL_SOC_BOOKE instead of CONFIG_PPC_85xx as
CONFIG_PPC_85xx isn't defined when we build support for 64-bit embedded
FSL PPC SoCs.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/usb/host/ehci-fsl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 4336257..f002525 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -313,7 +313,7 @@ static void ehci_fsl_usb_setup(struct ehci_hcd *ehci)
 	}
 
 	if (pdata->have_sysif_regs) {
-#ifdef CONFIG_PPC_85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 		out_be32(non_ehci + FSL_SOC_USB_PRICTRL, 0x00000008);
 		out_be32(non_ehci + FSL_SOC_USB_AGECNTTHRSH, 0x00000080);
 #else
-- 
1.7.3.4

