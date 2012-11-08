Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2KHW7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:59:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52999 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab2KHW7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:59:18 -0500
Message-ID: <509C394F.7020108@ti.com>
Date: Thu, 8 Nov 2012 16:59:27 -0600
From: "Alexis R. Cortes" <alexis.cortes@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: <sarah.a.sharp@linux.intel.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brian.quach@ti.com>, <jorge.llamas@ti.com>
Subject: [PATCH] usb: host: xhci: Stricter conditional for Z1 system models
 for Compliance Mode Patch
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This minor patch creates a more stricter conditional for the Z1 sytems for applying
the Compliance Mode Patch, this to avoid the quirk to be applied to models that
contain a "Z1" in their dmi product string but are different from Z1 systems.

Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
---
 drivers/usb/host/xhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c9e419f..af8b552 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -480,7 +480,7 @@ static bool compliance_mode_recovery_timer_quirk_check(void)
 	if (strstr(dmi_product_name, "Z420") ||
 			strstr(dmi_product_name, "Z620") ||
 			strstr(dmi_product_name, "Z820") ||
-			strstr(dmi_product_name, "Z1"))
+			strstr(dmi_product_name, "Z1 Workstation"))
 		return true;
 
 	return false;
-- 
1.7.1
