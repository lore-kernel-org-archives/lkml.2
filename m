Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2HHOsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:48:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab2HHOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:48:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Zhao <richard.zhao@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/11] usb/ohci-omap: remove unused variable
Date: Wed,  8 Aug 2012 16:47:20 +0200
Message-Id: <1344437248-20560-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:FEt8siKoLCons0UQWXCPWIFcFQnCUL8gt+fIHkk2QDZ
 +DEkZ9Yn4hpNDBcOKZGxC+Gh7WSy5LfTKb7MiqPEFKFrdNizOE
 ciu/Wd+v6lf8sKGlwWqUNS/gsUhp11WjlRV27QAPZzIL6DAqWK
 Gf/YzvOWBR/4zL0iDkaxw6iSoWqTsp5i4xiRCc1K7w3qH18XrG
 bZWR6AbXUordnOiLlMEA8LzmKr4rSULk2OomR2zQOW3iAQbJcv
 zVbFiGshWMnkrA5FjxScH6uwt5TgovcrOdcdGfFMLfZa6d7kP6
 jHcbRQYz0aqT8mEU8cVpqjCjXnxfGYivIMiZsHXwrjjleyNSdQ
 6EQbhSNXdJlmDuSeuH1a6TDiJYb8EvW1VyOr+mRllOlJXXXyFo
 MC6abeOYCI8Ra2VWtFjHdxNTOlORkT6ZG0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c2e935a7d "USB: move transceiver from ehci_hcd and ohci_hcd to
hcd and rename it as phy" removed the last use of the "ohci" variable
in the usb_hcd_omap_remove function, but left the variable in place
unused.

Without this patch, building omap1_defconfig results in:

In file included from drivers/usb/host/ohci-hcd.c:1013:0:
drivers/usb/host/ohci-omap.c: In function 'usb_hcd_omap_remove':
drivers/usb/host/ohci-omap.c:406:19: warning: unused variable 'ohci' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Zhao <richard.zhao@freescale.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-omap.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index e7d75d2..f8b2d91 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -403,8 +403,6 @@ err0:
 static inline void
 usb_hcd_omap_remove (struct usb_hcd *hcd, struct platform_device *pdev)
 {
-	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
-
 	usb_remove_hcd(hcd);
 	if (!IS_ERR_OR_NULL(hcd->phy)) {
 		(void) otg_set_host(hcd->phy->otg, 0);
-- 
1.7.10

