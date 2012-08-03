Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2HCTqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:46:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58004 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2HCTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:26 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 3/6] drivers/misc/ti-st: chip_disable on timeout
Date: Fri, 3 Aug 2012 14:46:14 -0500
Message-ID: <1344023177-21167-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1344023177-21167-3-git-send-email-pavan_savoy@ti.com>
References: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-2-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-3-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

If the communication with the WiLink breaks down for whatever reasons & the
ti-st driver is unable to un-install the line-discipline during clean-up in
st_kim_stop, the GPIO should be held low (BT_EN=0) & the platform's chip
disable hook shall also be called.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 847406a..54ff644 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -524,7 +524,7 @@ long st_kim_stop(void *kim_data)
 			msecs_to_jiffies(LDISC_TIME));
 	if (!err) {		/* timeout */
 		pr_err(" timed out waiting for ldisc to be un-installed");
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
 	}
 
 	/* platform specific disable */
-- 
1.7.4.1

