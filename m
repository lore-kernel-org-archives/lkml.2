Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684Ab2JaOyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:54:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36513 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964937Ab2JaOym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:54:42 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] MFD: twl-core: Fix chip ID for the twl6030-pwm module
Date: Wed, 31 Oct 2012 15:54:37 +0100
Message-ID: <1351695277-8629-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct chip id is 1 since the PWM module is on address 0x49. With the
current TWL6030_MODULE_ID1 the kernel will crash early since:
#define TWL6030_MODULE_ID1 0x0E
and
static struct twl_client twl_modules[4];

Down in the stack we try to get the module by:
struct twl_client	*twl = &twl_modules[chip];

Which obviously going to do nasty things.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi Samuel,

Can you push this patch to 3.7?
Without this if the user enables the twl6030-pwm driver the kernel will not
going to boot on OMAP4.

Thank you,
Peter

 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 2624668..d7577cb 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -672,7 +672,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {
-		child = add_child(TWL6030_MODULE_ID1, "twl6030-pwm", NULL, 0,
+		child = add_child(SUB_CHIP_ID1, "twl6030-pwm", NULL, 0,
 				  false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
-- 
1.7.12.4

