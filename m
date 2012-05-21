Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2EUK3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:29:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57484 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757233Ab2EUK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:29:52 -0400
From: Emil Goode <emilgoode@gmail.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [SCSI] scsi_pm: Argument to scsi_device_resume should be scsi_device pointer
Date: Mon, 21 May 2012 12:32:00 +0200
Message-Id: <1337596320-32330-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to scsi_device_resume expects a struct scsi_device pointer.
We should use the to_scsi_device macro here.

Sparse is warning about this:
drivers/scsi/scsi_pm.c:30:5: warning:
	passing argument 1 of ‘scsi_device_resume’
	from incompatible pointer type [enabled by default]
	include/scsi/scsi_device.h:368:13: note:
	expected ‘struct scsi_device *’
	but argument is of type ‘struct device *’

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/scsi/scsi_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 9bd2c41..d4201de 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -27,7 +27,7 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 		if (drv && drv->suspend) {
 			err = drv->suspend(dev, msg);
 			if (err)
-				scsi_device_resume(dev);
+				scsi_device_resume(to_scsi_device(dev));
 		}
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
-- 
1.7.10

