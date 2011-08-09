Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HITkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:40:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58065 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1HITjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:16 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 7/8] drivers:misc: ti-st: free skb on firmware download
Date: Tue, 9 Aug 2011 14:39:08 -0500
Message-ID: <1312918749-29627-17-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-16-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-10-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-11-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-12-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-13-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-14-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-15-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-16-git-send-email-pavan_savoy@ti.com>
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

Change-Id: I78dc3bdc4ea87faa5dce7eea61371718999d3f87
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index d8ca406..3a35805 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -68,6 +68,7 @@ void validate_firmware_response(struct kim_data_s *kim_gdata)
 	if (unlikely(skb->data[5] != 0)) {
 		pr_err("no proper response during fw download");
 		pr_err("data6 %x", skb->data[5]);
+		kfree_skb(skb);
 		return;		/* keep waiting for the proper response */
 	}
 	/* becos of all the script being downloaded */
-- 
1.7.4.1

