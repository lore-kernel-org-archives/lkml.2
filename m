Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2AKHvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:51:36 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54934 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab2AKHvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:51:35 -0500
Message-ID: <1326267877.15588.3.camel@phoenix>
Subject: [PATCH 2/3] power_supply: da9052-battery: Fix a memory leak when
 unload the module
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>
Date: Wed, 11 Jan 2012 15:44:37 +0800
In-Reply-To: <1326267824.15588.2.camel@phoenix>
References: <1326267824.15588.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/da9052-battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index 07d5b36..daf52a4 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -634,6 +634,7 @@ static int __devexit da9052_bat_remove(struct platform_device *pdev)
 		free_irq(bat->da9052->irq_base + irq, bat);
 	}
 	power_supply_unregister(&bat->psy);
+	kfree(bat);
 
 	return 0;
 }
-- 
1.7.5.4



