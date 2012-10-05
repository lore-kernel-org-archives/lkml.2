Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2JEO4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:56:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2JEOz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:55:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 09/16] USB: EHCI: mark ehci_orion_conf_mbus_windows __devinit
Date: Fri,  5 Oct 2012 16:55:23 +0200
Message-Id: <1349448930-23976-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ZicKctqEDHf4Kprr51zys7Om/5lSZTZpViHVV/gFGUQ
 z0kgksG6f3RZasc+K3Phd3IIXX+lySxNLUsBBgEseVRfOIJ+q4
 jQI9t2YxRGi91czJ74HAekY0MIhp1ba4Ijbf23sR+rA5sOcDjR
 qVxdJ2te8DPE6PJwn2nav9tfqIwG6wRHy9ODH/9DzaD1cGqta4
 bVP62u3ko2M5230/2hg1Wt4FZ0L462soqy9bOGf7g0CbHdxuwC
 WEe+Y8Ef3HVdr6WsBXrP5M69K1O/UOYD2Qg+79R0Dibn49ktEh
 gVOn55/LAdHmBBxeEj1Cw8G0tDrEQvd8jksEi+XK8rjk84c4/x
 LXAQ0tNeb7bqEQ8QDYgwLfzmiFNrbgkNlIgZaysXb2mv7J2xbs
 D1JXGwcU4MNkf8XVlwNnsbhKtFEF7L7wpY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __devinit section is going away soon, but while it's
still there, we get a correct warning about
ehci_orion_conf_mbus_windows being discarded before
its caller, so it should be marked __devinit rather than
__init.

Without this patch, building dove_defconfig results in:

WARNING: drivers/usb/host/built-in.o(.devinit.text+0x8a4): Section mismatch in reference from the function ehci_orion_drv_probe() to the function .init.text:ehci_orion_conf_mbus_windows()
The function __devinit ehci_orion_drv_probe() references
a function __init ehci_orion_conf_mbus_windows().
If ehci_orion_conf_mbus_windows is only used by ehci_orion_drv_probe then
annotate ehci_orion_conf_mbus_windows with a matching annotation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/ehci-orion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 8892d36..1f5dd5e 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -160,7 +160,7 @@ static const struct hc_driver ehci_orion_hc_driver = {
 	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
-static void __init
+static void __devinit
 ehci_orion_conf_mbus_windows(struct usb_hcd *hcd,
 			     const struct mbus_dram_target_info *dram)
 {
-- 
1.7.10

