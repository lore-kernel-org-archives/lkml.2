Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1KRAol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 19:44:41 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:58772 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab1KRAok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:44:40 -0500
From: Richard Weinberger <richard@nod.at>
To: JBottomley@parallels.com
Cc: Babu.moger@netapp.com, Somasundaram.Krishnasamy@lsi.com,
        yanling.qi@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] scsi_dh_rdac: Fix error path
Date: Fri, 18 Nov 2011 01:44:27 +0100
Message-Id: <1321577067-26332-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If create_singlethread_workqueue() failes, rdac_init should fail too.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1d31279..2802394 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -934,6 +934,8 @@ static int __init rdac_init(void)
 	if (!kmpath_rdacd) {
 		scsi_unregister_device_handler(&rdac_dh);
 		printk(KERN_ERR "kmpath_rdacd creation failed.\n");
+
+		r = -EINVAL;
 	}
 done:
 	return r;
-- 
1.7.7.3

