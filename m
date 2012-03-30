Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2C3LGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:06:51 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:58005
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755769Ab2C3LGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:06:43 -0400
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        Rupesh Gujare <rgujare@ozmodevices.com>
Subject: [PATCH] Fix USB Kconfig
Date: Fri, 30 Mar 2012 12:05:32 +0100
Message-ID: <1333105532-7668-1-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120330100056.GA27427@x1.osrc.amd.com>
References: <20120330100056.GA27427@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix menuconfig option for USB. 

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
Reported-by: Borislav Petkov <bp@alien8.de>
---
 drivers/usb/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index cbd8f5f..884f3fa 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -10,6 +10,13 @@ menuconfig USB_SUPPORT
 	  This option adds core support for Universal Serial Bus (USB).
 	  You will also need drivers from the following menu to make use of it.
 
+if USB_SUPPORT
+
+config USB_COMMON
+	tristate
+	default y
+	depends on USB || USB_GADGET
+
 # many non-PCI SOC chips embed OHCI
 config USB_ARCH_HAS_OHCI
 	boolean
@@ -63,13 +70,6 @@ config USB_ARCH_HAS_XHCI
 	boolean
 	default PCI
 
-if USB_SUPPORT
-
-config USB_COMMON
-	tristate
-	default y
-	depends on USB || USB_GADGET
-
 # Host-side USB depends on having a host controller
 # NOTE:  dummy_hcd is always an option, but it's ignored here ...
 # NOTE:  SL-811 option should be board-specific ...
-- 
1.7.5.4


