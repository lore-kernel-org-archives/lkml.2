Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2BTJIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:08:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:4711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2BTJHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:07:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108566946"
From: Alex Shi <alex.shi@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, andiry.xu@amd.com,
        clemens@ladisch.de, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] usb: export usb_hcd_request_irqs
Date: Mon, 20 Feb 2012 17:05:33 +0800
Message-Id: <1329728733-32419-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1329728733-32419-3-git-send-email-alex.shi@intel.com>
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
 <1329728733-32419-2-git-send-email-alex.shi@intel.com>
 <1329728733-32419-3-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May it is possible be used by drivers.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/usb/core/hcd.c  |    1 +
 include/linux/usb/hcd.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 579cbd3..226235a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2375,6 +2375,7 @@ int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(usb_hcd_request_irqs);
 
 /**
  * usb_add_hcd - finish generic HCD structure initialization and register
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 5253c02..d58e710 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -392,6 +392,8 @@ extern int usb_hcd_is_primary_hcd(struct usb_hcd *hcd);
 extern int usb_add_hcd(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags);
 extern void usb_remove_hcd(struct usb_hcd *hcd);
+extern int usb_hcd_request_irqs(struct usb_hcd *hcd,
+		unsigned int irqnum, unsigned long irqflags);
 
 struct platform_device;
 extern void usb_hcd_platform_shutdown(struct platform_device *dev);
-- 
1.6.3.3

