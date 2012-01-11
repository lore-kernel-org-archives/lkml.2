Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2AKHn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:43:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65204 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2AKHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:43:56 -0500
Message-ID: <1326267824.15588.2.camel@phoenix>
Subject: [PATCH 1/3] power_supply: da9052-battery: Add missing
 platform_set_drvdata
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>
Date: Wed, 11 Jan 2012 15:43:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing platform_set_drvdata in da9052_bat_probe.
Otherwise, calling platform_get_drvdata in da9052_bat_remove returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/da9052-battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index e8ea47a..07d5b36 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -612,6 +612,7 @@ static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
 	 if (ret)
 		goto err;
 
+	platform_set_drvdata(pdev, bat);
 	return 0;
 
 err:
-- 
1.7.5.4



