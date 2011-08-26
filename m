Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1HZUfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:35:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab1HZUeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/13] drivers:misc: ti-st: free skb on firmware download
Date: Fri, 26 Aug 2011 13:33:53 -0700
Message-Id: <1314390834-3411-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

If during validation of the firmware download the data doesn't match what is
expected out of the chip, this calls for a firmware download failure and a
retry.
Free the SKB which collects response during such scenarios.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

