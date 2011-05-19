Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889Ab1ESVf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:35:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59113 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1ESVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YSvOJ6QT8uZ9QuSAjKpzqmWTbbzR5TNNAAm05/l92oLjo7HxJiB3puqbmjLmCkXBaU
         4BYiLvHG1FSuFIY4+xocdbEeFsCNTtUPN+EanM3hN5U6UJhWqGvtDQjkCV0xW1r1W7wL
         vIA3D/MC3np/n3eI6MRmAlUDeSBThQ7pi3nJ0=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux390@de.ibm.com
Subject: [PATCH 07/23] use register_chrdev_ids in drivers/s390/
Date: Thu, 19 May 2011 15:33:10 -0600
Message-Id: <1305840792-25877-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-s390@vger.kernel.org
cc: linux390@de.ibm.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/s390/char/tape_char.c |    2 +-
 drivers/s390/char/vmlogrdr.c  |    2 +-
 drivers/s390/char/vmur.c      |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index 87cd0ab..e321435 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -494,7 +494,7 @@ tapechar_init (void)
 {
 	dev_t	dev;
 
-	if (alloc_chrdev_region(&dev, 0, 256, "tape") != 0)
+	if (register_chrdev_ids(&dev, 256, "tape") != 0)
 		return -1;
 
 	tapechar_major = MAJOR(dev);
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index c837d74..15eeab7 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -866,7 +866,7 @@ static int __init vmlogrdr_init(void)
 
         recording_class_AB = vmlogrdr_get_recording_class_AB();
 
-	rc = alloc_chrdev_region(&dev, 0, MAXMINOR, "vmlogrdr");
+	rc = register_chrdev_ids(&dev, MAXMINOR, "vmlogrdr");
 	if (rc)
 		return rc;
 	vmlogrdr_major = MAJOR(dev);
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index f6b00c3..e752c84 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -1037,9 +1037,9 @@ static int __init ur_init(void)
 	if (rc)
 		goto fail_class_destroy;
 
-	rc = alloc_chrdev_region(&dev, 0, NUM_MINORS, "vmur");
+	rc = register_chrdev_ids(&dev, NUM_MINORS, "vmur");
 	if (rc) {
-		pr_err("Kernel function alloc_chrdev_region failed with "
+		pr_err("register_chrdev_ids() failed with "
 		       "error code %d\n", rc);
 		goto fail_unregister_driver;
 	}
-- 
1.7.4.4

