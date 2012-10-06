Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2JFFcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 01:32:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53462 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2JFFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 01:32:47 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/adl_pci8164.c
Date: Sat,  6 Oct 2012 14:32:40 +0900
Message-Id: <1349501560-7471-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349395666-6010-1-git-send-email-yamanetoshi@gmail.com>
References: <1349395666-6010-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci8164.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 05e06e7..5a6d6d2 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -89,9 +89,9 @@ static void adl_pci8164_insn_read(struct comedi_device *dev,
 	}
 
 	data[0] = inw(dev->iobase + axis_reg + offset);
-	printk(KERN_DEBUG "comedi: pci8164 %s read -> "
-						  "%04X:%04X on axis %s\n",
-				action, data[0], data[1], axisname);
+	dev_dbg(dev->class_dev,
+		"pci8164 %s read -> %04X:%04X on axis %s\n",
+		action, data[0], data[1], axisname);
 }
 
 static int adl_pci8164_insn_read_msts(struct comedi_device *dev,
@@ -170,9 +170,9 @@ static void adl_pci8164_insn_out(struct comedi_device *dev,
 
 	outw(data[0], dev->iobase + axis_reg + offset);
 
-	printk(KERN_DEBUG "comedi: pci8164 %s write -> "
-						"%04X:%04X on axis %s\n",
-				action, data[0], data[1], axisname);
+	dev_dbg(dev->class_dev,
+		"pci8164 %s write -> %04X:%04X on axis %s\n",
+		action, data[0], data[1], axisname);
 
 }
 
-- 
1.7.9.5

