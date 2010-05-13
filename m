Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0EMP53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:57:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:33058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028Ab0EMP5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:57:22 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org
Cc: ben@decadent.org.uk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] libata: use the enlarged capacity after late HPA unlock
Date: Thu, 13 May 2010 17:56:45 +0200
Message-Id: <1273766206-17402-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273766206-17402-1-git-send-email-tj@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 15:56:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After late HPA unlock, libata kept using the original capacity
ignoring the new larger native capacity.  Enlarging device on the fly
doesn't cause any harm.  Use the larger native capacity instead.  This
will enable on-demand HPA unlocking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 86f405b..9d6e92d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4212,9 +4212,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	    dev->n_sectors > n_sectors && dev->n_sectors == n_native_sectors) {
 		ata_dev_printk(dev, KERN_WARNING,
 			       "new n_sectors matches native, probably "
-			       "late HPA unlock, continuing\n");
-		/* keep using the old n_sectors */
-		dev->n_sectors = n_sectors;
+			       "late HPA unlock, n_sectors updated\n");
+		/* use the larger n_sectors */
 		return 0;
 	}
 
-- 
1.6.4.2

