Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2HCTqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:46:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56388 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab2HCTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:25 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Matthias Kaehlcke <matthias@kaehlcke.net>,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 6/6] drivers/misc/ti-st: check chip_awake NULL check
Date: Fri, 3 Aug 2012 14:46:17 -0500
Message-ID: <1344023177-21167-7-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1344023177-21167-6-git-send-email-pavan_savoy@ti.com>
References: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-2-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-3-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-4-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-5-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-6-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias@kaehlcke.net>

Before calling on any of the platform hooks, shared transport driver checks
for the validity of the platform hooks as to whether it is provided or not.
A wrong function was being checked for, before the chip_awake hook was called
by the HCI-LL sleep logic handler. This patch corrects the check.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/misc/ti-st/st_ll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
index 1ff460a..93b4d67 100644
--- a/drivers/misc/ti-st/st_ll.c
+++ b/drivers/misc/ti-st/st_ll.c
@@ -87,7 +87,7 @@ static void ll_device_want_to_wakeup(struct st_data_s *st_data)
 	/* communicate to platform about chip wakeup */
 	kim_data = st_data->kim_data;
 	pdata = kim_data->kim_pdev->dev.platform_data;
-	if (pdata->chip_asleep)
+	if (pdata->chip_awake)
 		pdata->chip_awake(NULL);
 }
 
-- 
1.7.4.1

