Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1FPMPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:24 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55419 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757681Ab1FPMPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:19 -0400
Date: Thu, 16 Jun 2011 14:15:16 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 10/11] wusb: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <f69548c31f74b77bdc893772ef4012461dff119d.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited()

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/usb/wusbcore/wa-xfer.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 6ccd93a..4193345 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -83,6 +83,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/ratelimit.h>
 
 #include "wa-hc.h"
 #include "wusbhc.h"
@@ -1217,16 +1218,14 @@ static int wa_xfer_status_to_errno(u8 status)
 	if (status == 0)
 		return 0;
 	if (status >= ARRAY_SIZE(xlat)) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "%s(): BUG? "
+		printk_ratelimited(KERN_ERR "%s(): BUG? "
 			       "Unknown WA transfer status 0x%02x\n",
 			       __func__, real_status);
 		return -EINVAL;
 	}
 	errno = xlat[status];
 	if (unlikely(errno > 0)) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "%s(): BUG? "
+		printk_ratelimited(KERN_ERR "%s(): BUG? "
 			       "Inconsistent WA status: 0x%02x\n",
 			       __func__, real_status);
 		errno = -errno;
-- 
1.7.4.1

