Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0F0Rkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 13:40:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54610 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0F0Rkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 13:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gTIrM1HDgTBRmtcxejAY+PrwM4AvvjhH2NI0cz+f5oWtHFt04K+9hP6jKUHp0G2+sy
         LMrmwuEYoUgoMmf3LrBO3PIqOLJ7eIR6o1kj9SFbEJBkrZC7cxwxtIISOruowtYoElPA
         H+pKfr+B05M3gefN14IUmd+eYhg5pYBlC11WY=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, tj@kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: kcomedilib: fix coding style issues in kcomedilib_main.c
Date: Sun, 27 Jun 2010 12:40:31 -0500
Message-Id: <1277660431-10284-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the kcomedilib_main.c file that fixes up some printk() warning issues.

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 863aae4..0252b44 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -93,7 +93,7 @@ static int comedi_do_insn(struct comedi_device *dev, struct comedi_insn *insn)
 	s = dev->subdevices + insn->subdev;
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
-		printk("%d not useable subdevice\n", insn->subdev);
+		printk(KERN_ERR "%d not useable subdevice\n", insn->subdev);
 		ret = -EIO;
 		goto error;
 	}
@@ -102,7 +102,7 @@ static int comedi_do_insn(struct comedi_device *dev, struct comedi_insn *insn)
 
 	ret = comedi_check_chanlist(s, 1, &insn->chanspec);
 	if (ret < 0) {
-		printk("bad chanspec\n");
+		printk(KERN_ERR "bad chanspec\n");
 		ret = -EINVAL;
 		goto error;
 	}
-- 
1.7.1

