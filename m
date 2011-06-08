Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1FHJod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:44:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:53043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab1FHJo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,337,1304319600"; 
   d="scan'208";a="13429066"
From: Heikki Krogerus <krohei@gmail.com>
To: Greg KH <gregkh@suse.de>, Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] isp1704_charger: Handle suspended and resumed events
Date: Wed,  8 Jun 2011 12:44:40 +0300
Message-Id: <1307526281-12125-3-git-send-email-krohei@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307526281-12125-1-git-send-email-krohei@gmail.com>
References: <1307526281-12125-1-git-send-email-krohei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent charging when the bus is suspended, handling
suspended and resumed events.

Signed-off-by: Heikki Krogerus <krohei@gmail.com>
---
 drivers/power/isp1704_charger.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index f6d72b4..c0d4e8b 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -294,6 +294,19 @@ static void isp1704_charger_work(struct work_struct *data)
 		else
 			isp->current_max = power;
 		break;
+	case USB_EVENT_SUSPENDED:
+		/* Ignore SUSPEND with CDP */
+		if (isp->present)
+			goto out;
+		else
+			isp->current_max = 2;
+		break;
+	case USB_EVENT_RESUMED:
+		if (isp->present)
+			goto out;
+		else
+			isp->current_max = power;
+		break;
 	default:
 		goto out;
 	}
-- 
1.7.4.1

