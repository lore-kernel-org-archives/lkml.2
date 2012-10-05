Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2JEAHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 20:07:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50957 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JEAHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 20:07:14 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in kcomedilib/kcomedilib_main.c
Date: Fri,  5 Oct 2012 09:07:00 +0900
Message-Id: <1349395621-5941-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 3f20ea5..944ba9d 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -95,7 +95,8 @@ static int comedi_do_insn(struct comedi_device *dev,
 	s = &dev->subdevices[insn->subdev];
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
-		printk(KERN_ERR "%d not useable subdevice\n", insn->subdev);
+		dev_err(dev->class_dev,
+			"%d not useable subdevice\n", insn->subdev);
 		ret = -EIO;
 		goto error;
 	}
@@ -104,7 +105,7 @@ static int comedi_do_insn(struct comedi_device *dev,
 
 	ret = comedi_check_chanlist(s, 1, &insn->chanspec);
 	if (ret < 0) {
-		printk(KERN_ERR "bad chanspec\n");
+		dev_err(dev->class_dev, "bad chanspec\n");
 		ret = -EINVAL;
 		goto error;
 	}
-- 
1.7.9.5

