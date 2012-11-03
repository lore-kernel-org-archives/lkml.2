Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2KCNkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 09:40:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36634 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2KCNkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 09:40:18 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/comedi_fc.c
Date: Sat,  3 Nov 2012 22:40:13 +0900
Message-Id: <1351950013-16234-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/comedi_fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index 63be619..8372829 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -53,7 +53,7 @@ unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *subd,
 
 	retval = comedi_buf_write_alloc(async, num_bytes);
 	if (retval != num_bytes) {
-		printk(KERN_WARNING "comedi: buffer overrun\n");
+		dev_warn(subd->device->class_dev, "comedi: buffer overrun\n");
 		async->events |= COMEDI_CB_OVERFLOW;
 		return 0;
 	}
-- 
1.7.9.5

