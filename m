Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2FKPZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41743 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2FKPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 06/14] mfd: Initialise the DB8500 PRCMU driver at core_initcall time
Date: Mon, 11 Jun 2012 16:24:59 +0100
Message-Id: <1339428307-3850-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the AB8500 has its own IRQ domain it needs to be initialised earlier
in the boot sequence. As the AB8500 relies on the DB8500 PRCMU we need to
reflect this change for the PRCMU driver too.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index c702f18..1aa0bb7 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3023,7 +3023,7 @@ static int __init db8500_prcmu_init(void)
 	return platform_driver_register(&db8500_prcmu_driver);
 }
 
-arch_initcall(db8500_prcmu_init);
+core_initcall(db8500_prcmu_init);
 
 MODULE_AUTHOR("Mattias Nilsson <mattias.i.nilsson@stericsson.com>");
 MODULE_DESCRIPTION("DB8500 PRCM Unit driver");
-- 
1.7.9.5

