Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab2EPIMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:12:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15028 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2EPIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:12:26 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-3d-4fb36169d6d5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Andrzej Zaborowski'" <balrogg@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v3 6/7] backlight: omap1: use pr_info instead of printk
Date: Wed, 16 May 2012 17:12:25 +0900
Message-id: <003901cd333b$a0af1c10$e20d5430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zO6CY7X7rR6arR/qhIZX4rWNZZg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_info instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used. It also fixes checkpatch
warning as below:

WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Cc: Andrzej Zaborowski <balrogg@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/omap1_bl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 0175bfb..bfdc5fb 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -168,7 +170,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	dev->props.brightness = pdata->default_intensity;
 	omapbl_update_status(dev);
 
-	printk(KERN_INFO "OMAP LCD backlight initialised\n");
+	pr_info("OMAP LCD backlight initialised\n");
 
 	return 0;
 }
-- 
1.7.1


