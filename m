Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1HJPVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:21:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57147 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab1HJPSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:18:46 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 7/8] drivers:misc: ti-st: free skb on firmware download
Date: Wed, 10 Aug 2011 10:18:36 -0500
Message-ID: <1312989517-28604-8-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312989517-28604-7-git-send-email-pavan_savoy@ti.com>
References: <1312989517-28604-1-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-2-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-3-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-4-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-5-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-6-git-send-email-pavan_savoy@ti.com>
 <1312989517-28604-7-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

If during validation of the firmware download the data doesn't match what is
expected out of the chip, this calls for a firmware download failure and a
retry.
Free the SKB which collects response during such scenarios.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index ee20fa9..43ef8d1 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -69,6 +69,7 @@ void validate_firmware_response(struct kim_data_s *kim_gdata)
 	if (unlikely(skb->data[5] != 0)) {
 		pr_err("no proper response during fw download");
 		pr_err("data6 %x", skb->data[5]);
+		kfree_skb(skb);
 		return;		/* keep waiting for the proper response */
 	}
 	/* becos of all the script being downloaded */
-- 
1.7.4.1

