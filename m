Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab0I0HHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:07:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57256 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab0I0HHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jJsPbpbjZxhLMUZy+zuOO6MVQs5qhqbUHQa3+8N2k0e0PWaRnE9Z+PIx19bKSEugxU
         d6NKIITmiu8MgntPh6Wrg9qmCtxZdkEryEuOtm3mS2EGZkT6Ised3Ye8PbupJ61AaFYH
         X5DQB7uyR0bDJk0LhdR9/X6qD+In6pTLsTUnQ=
Subject: [PATCH 1/3] drivers/power: add missing kfree(di) in
	ds2760_battery_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Sep 2010 15:07:12 +0800
Message-Id: <1285571232.31251.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/ds2760_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 4d3b272..b3c01c1 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -586,6 +586,7 @@ static int ds2760_battery_remove(struct platform_device *pdev)
 					  &di->set_charged_work);
 	destroy_workqueue(di->monitor_wqueue);
 	power_supply_unregister(&di->bat);
+	kfree(di);
 
 	return 0;
 }
-- 
1.7.2



