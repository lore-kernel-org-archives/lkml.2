Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab2EROIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:08:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18759 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2EROIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:08:48 -0400
Date: Fri, 18 May 2012 17:08:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Aaron Lu <Aaron.Lu@amd.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [patch] [SCSI] scsi_pm: passing wrong pointer to resume()
Message-ID: <20120518140827.GA1584@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets caught by GCC:
drivers/scsi/scsi_pm.c:30:5: warning: passing argument 1 of
	‘scsi_device_resume’ from incompatible pointer type
	[enabled by default]

It probably would have been caught in testing as well, but it's on an
error path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I haven't tested this.  :/  Sorry for that.

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
