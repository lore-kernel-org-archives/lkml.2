Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2FKPZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49364 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2FKPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/14] mfd: Initialise the AB8500 driver at core_initcall time
Date: Mon, 11 Jun 2012 16:25:00 +0100
Message-Id: <1339428307-3850-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 is soon to have its own IRQ domain. For this to be useful
the driver needs to be initialised earlier in the boot sequence. Here
we move initialisation forward from arch_initcall to core_initcall time.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index dac0e29..4dc5024 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1484,7 +1484,7 @@ static void __exit ab8500_core_exit(void)
 {
 	platform_driver_unregister(&ab8500_core_driver);
 }
-arch_initcall(ab8500_core_init);
+core_initcall(ab8500_core_init);
 module_exit(ab8500_core_exit);
 
 MODULE_AUTHOR("Mattias Wallin, Srinidhi Kasagar, Rabin Vincent");
-- 
1.7.9.5

