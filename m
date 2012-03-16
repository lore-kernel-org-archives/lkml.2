Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2CPSew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:34:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41697 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2CPSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:34:42 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: sarah.a.sharp@linux.intel.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: xhci: fix section mismatch in linux-next
Date: Fri, 16 Mar 2012 11:34:11 -0700
Message-Id: <1331922851-28513-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci_unregister_pci() is called in xhci_hcd_init().

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/usb/host/xhci-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index ef98b38..0d7b851 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -326,7 +326,7 @@ int __init xhci_register_pci(void)
 	return pci_register_driver(&xhci_pci_driver);
 }
 
-void __exit xhci_unregister_pci(void)
+void xhci_unregister_pci(void)
 {
 	pci_unregister_driver(&xhci_pci_driver);
 }
-- 
1.7.7.6

