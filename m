Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0EOSKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:10:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:40245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0EOSKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:10:08 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] libata: use the enlarged capacity after late HPA unlock
Date: Sat, 15 May 2010 20:09:33 +0200
Message-Id: <1273946974-29131-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 May 2010 18:09:41 +0000 (UTC)
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

