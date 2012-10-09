Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2JIUP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:15:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2JIUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 4/8] USB: EHCI: mark ehci_orion_conf_mbus_windows __devinit
Date: Tue,  9 Oct 2012 22:13:54 +0200
Message-Id: <1349813638-4617-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xX7UFas9oO8MuMTFYEO0qxxKVwYCwI/k728wnc8oubN
 /LlzUgg23MNpNEXu7uG0jRBj1T1/tBfJZwnq3NzTv4WBny0vjl
 trbYyrjOr+/izgRvtkLrHO5tLZ1EXwPIMBArX9G5X9eYVmFuwB
 HgqGB9IMEuHamMF53DPViLdaMs4qKikytdloPa0015NOrcZrUq
 vzsPEb9pSiBBWFqKjwRXVB553uvV98aPsloohuc3Db0y9Gnpn+
 wWG5IvSurDR2V96ZQLUkwbh1YsGju4TjRZMCfK6FV7WSXRvWrD
 K6kEi8EiRjs3+amNZrgb98qdmzFH00k2BcscgubnONTpKguhvX
 8HYjoM1SleVx00TYsO2+AYbR8ahiaD4odGMiQFO/o
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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
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

