Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967316Ab2EPFMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:12:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2EPFMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:12:41 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-f2-4fb33748281b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Andrzej Zaborowski'" <balrogg@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 6/7] backlight: omap1: use pr_info instead of printk
Date: Wed, 16 May 2012 14:12:39 +0900
Message-id: <002401cd3322$84083f10$8c18bd30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zIoPu9uGbfJvkR46Dd4qdZEXuyg==
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
index 0175bfb..869973f 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) "omap1_bl: " fmt
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


