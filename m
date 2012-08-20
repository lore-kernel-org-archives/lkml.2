Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2HTTjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:39:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:46702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2HTTjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:39:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,798,1336374000"; 
   d="scan'208";a="183097948"
From: Andi Kleen <andi@firstfloor.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        greg@kroah.com
Subject: [PATCH] USB: Build usb_speed_string unconditionally
Date: Mon, 20 Aug 2012 12:38:28 -0700
Message-Id: <1345491508-30966-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The usb core uses usb_speed_string(). But it's only selected
for USB_GADGET. Enable it unconditionally.

Fixes a lot of randconfig builds.

Cc: greg@kroah.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index f5ed3d7..d74535b 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -57,4 +57,4 @@ obj-$(CONFIG_USB_CHIPIDEA)	+= chipidea/
 obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
 obj-$(CONFIG_USB_GADGET)	+= gadget/
 
-obj-$(CONFIG_USB_COMMON)	+= usb-common.o
+obj-y				+= usb-common.o
-- 
1.7.7.6

