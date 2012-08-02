Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2HBUSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:18:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57802 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2HBUSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:18:31 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 83.160.107.163
Date: Thu, 2 Aug 2012 22:17:48 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ti-st: Fix check for pdata->chip_awake function pointer
Message-ID: <20120802201748.GA4358@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Pavan Savoy <pavan_savoy@ti.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ll_device_want_to_wakeup(): Fix the NULL pointer check on pdata->chip_awake,
which is performed on the wrong function pointer

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/misc/ti-st/st_ll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.7.10

