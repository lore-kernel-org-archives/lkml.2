Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1FHJoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:44:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:53043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1FHJoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,337,1304319600"; 
   d="scan'208";a="13429072"
From: Heikki Krogerus <krohei@gmail.com>
To: Greg KH <gregkh@suse.de>, Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/3] twl4030_charger:  Handle suspended and resumed events
Date: Wed,  8 Jun 2011 12:44:41 +0300
Message-Id: <1307526281-12125-4-git-send-email-krohei@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307526281-12125-1-git-send-email-krohei@gmail.com>
References: <1307526281-12125-1-git-send-email-krohei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent charging when the bus is suspended, handling
suspended and resumed events.

Signed-off-by: Heikki Krogerus <krohei@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/twl4030_charger.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 92c16e1..461c389 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -268,11 +268,15 @@ static void twl4030_bci_usb_work(struct work_struct *data)
 	switch (bci->event) {
 	case USB_EVENT_VBUS:
 	case USB_EVENT_CHARGER:
+	case USB_EVENT_RESUMED:
 		twl4030_charger_enable_usb(bci, true);
 		break;
 	case USB_EVENT_NONE:
+	case USB_EVENT_SUSPENDED:
 		twl4030_charger_enable_usb(bci, false);
 		break;
+	default:
+		break;
 	}
 }
 
-- 
1.7.4.1

