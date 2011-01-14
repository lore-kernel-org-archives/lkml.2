Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1ANJjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:39:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57503 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1ANJjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=w+s3A1FDYOs0JbPUgsf+P6tma/LkNla2Oqn6F1MMJ7ihhvB6LB0roXSXJWYui1a/ek
         SY80hkmGEfilpPzD5dVT5M2g29AupeVc9upSCh041qRV2WMJdkXiO6QAi0MzfwCQsShT
         LzA5sPgxua807xtfWUzRwg386D9BsALPfStwI=
Subject: [PATCH] video: pxa3xx-gcu: Return -EFAULT when copy_from_user()
	fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Janine Kropp <nin@directfb.org>,
        Denis Oliver Kropp <dok@directfb.org>,
        Eric Miao <eric.y.miao@gmail.com>, linux-fbdev@vger.kernel.org
Content-Type: text/plain
Date: Fri, 14 Jan 2011 17:39:11 +0800
Message-Id: <1294997951.12295.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EFAULT instead of number of bytes that could not be copied if
copy_from_user() fails.

Also fix a typo in the comments.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/pxa3xx-gcu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
index b81168d..cf4beb9 100644
--- a/drivers/video/pxa3xx-gcu.c
+++ b/drivers/video/pxa3xx-gcu.c
@@ -1,5 +1,5 @@
 /*
- *  pxa3xx-gc.c - Linux kernel module for PXA3xx graphics controllers
+ *  pxa3xx-gcu.c - Linux kernel module for PXA3xx graphics controllers
  *
  *  This driver needs a DirectFB counterpart in user space, communication
  *  is handled via mmap()ed memory areas and an ioctl.
@@ -421,7 +421,7 @@ pxa3xx_gcu_misc_write(struct file *filp, const char *buff,
 		buffer->next = priv->free;
 		priv->free = buffer;
 		spin_unlock_irqrestore(&priv->spinlock, flags);
-		return ret;
+		return -EFAULT;
 	}
 
 	buffer->length = words;
-- 
1.7.2



