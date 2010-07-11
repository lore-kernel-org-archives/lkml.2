Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0GKTMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 15:12:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32791 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0GKTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R0gWBBoieaU9KOG2aPkTB5saenJUinUoU/5LH+3S6Rzb43zFd21I2WEa1pfdEc5lA7
         5MkRWOuelSFvjY6L5gcX1zkPcc3HfQkum35RmlCxXcqdc5HTkGc0LskC9msi60bfhAK4
         JZGC8x0o9xJ6xk1bBAAflQInW8fFAuELFNlmk=
From: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, vasu.dev@intel.com,
        akpm@linux-foundation.org, James.Bottomley@suse.de,
        anil_ravindranath@pmc-sierra.com,
        Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
Subject: [PATCH] pmcraid : Remove unwanted cast for void * pointers
Date: Mon, 12 Jul 2010 00:42:00 +0530
Message-Id: <1278875520-18592-1-git-send-email-cyril.jayaprakash@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>

Patch to remove unwanted cast for void * pointers.

Signed-off-by: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
---
 drivers/scsi/pmcraid.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index c44e4ab..bd0b5a0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3324,8 +3324,7 @@ static int pmcraid_chr_open(struct inode *inode, struct file *filep)
  */
 static int pmcraid_chr_release(struct inode *inode, struct file *filep)
 {
-	struct pmcraid_instance *pinstance =
-		((struct pmcraid_instance *)filep->private_data);
+	struct pmcraid_instance *pinstance = filep->private_data;
 
 	filep->private_data = NULL;
 	fasync_helper(-1, filep, 0, &pinstance->aen_queue);
@@ -3344,7 +3343,7 @@ static int pmcraid_chr_fasync(int fd, struct file *filep, int mode)
 	struct pmcraid_instance *pinstance;
 	int rc;
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 	mutex_lock(&pinstance->aen_queue_lock);
 	rc = fasync_helper(fd, filep, mode, &pinstance->aen_queue);
 	mutex_unlock(&pinstance->aen_queue_lock);
@@ -3795,7 +3794,7 @@ static long pmcraid_chr_ioctl(
 		return retval;
 	}
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 
 	if (!pinstance) {
 		pmcraid_info("adapter instance is not found\n");
-- 
1.7.0.4

