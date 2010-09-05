Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0IEScq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0IEScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OjlfMg+HepBh0qWVMqbyWvm92KWkYpIiart1wUTqs/uPumk7mzpO93yH0+oN2CRX17
         bl29VehnIDknc7NPuEf5gBtKKu/JU3Xo41YzVzR6DP9dlTiM/XBHWt7zDXuVb5USlIpf
         ZyROZP7/MI3qRWPUhApPLO98UBEKx5jWtWfhM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ian Abbott <abbotti@mev.co.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Mark Rankilor <reodge@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] staging: comedi: check return code of put_user
Date: Sun,  5 Sep 2010 22:32:33 +0400
Message-Id: <1283711554-7287-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function put_user may fail. Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I couldn't compile this driver at all, so it is not tested.

 drivers/staging/comedi/comedi_fops.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 1409131..a3c7183 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -537,7 +537,8 @@ static int do_chaninfo_ioctl(struct comedi_device *dev,
 
 			x = (dev->minor << 28) | (it.subdev << 24) | (i << 16) |
 			    (s->range_table_list[i]->length);
-			put_user(x, it.rangelist + i);
+			if (put_user(x, it.rangelist + i))
+				return -EFAULT;
 		}
 #if 0
 		if (copy_to_user(it.rangelist, s->range_type_list,
-- 
1.7.0.4

