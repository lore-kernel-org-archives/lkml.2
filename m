Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0LARpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:45:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39443 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0LARph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:45:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=oufV0qVeD1T4g/FD7+r+tmi681wlzeaIh8qof4pYN72XTlyDcannn2yufTGXh365fV
         J7CUbORvIHlD81Vyq+wXktTn9Dl3zcQI8HvlodZH24H+ojFFVSl9aCns67NmK+2kjPrn
         AGrnJrTg3VW/40QSEExrTRgi1IvkpmUF9PqWI=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] USB: whci-hcd: move whci_hcd_id_table under #ifdef MODULE
Date: Thu,  2 Dec 2010 02:45:27 +0900
Message-Id: <1291225529-1118-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since whci_hcd_id_table is used only for module auto-loading
move it under #ifdef MODULE. This fixes following warning:

  CC      drivers/usb/host/whci/hcd.o
drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/usb/host/whci/hcd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/whci/hcd.c b/drivers/usb/host/whci/hcd.c
index 72b6892..ee76401 100644
--- a/drivers/usb/host/whci/hcd.c
+++ b/drivers/usb/host/whci/hcd.c
@@ -355,12 +355,14 @@ static void __exit whci_hc_driver_exit(void)
 }
 module_exit(whci_hc_driver_exit);
 
+#ifdef MODULE
 /* PCI device ID's that we handle (so it gets loaded) */
 static struct pci_device_id whci_hcd_id_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_WIRELESS_WHCI, ~0) },
 	{ /* empty last entry */ }
 };
 MODULE_DEVICE_TABLE(pci, whci_hcd_id_table);
+#endif
 
 MODULE_DESCRIPTION("WHCI Wireless USB host controller driver");
 MODULE_AUTHOR("Cambridge Silicon Radio Ltd.");
-- 
1.7.0.4

