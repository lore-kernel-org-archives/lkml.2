Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0LERuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0LERuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NLOUfciIsfw5uvzVhLB51/4ClNJZ9EEc3DXTa2/HkiuYpWWTo3/Unx8ed23j8bBsUA
         XDD5C8u0ejHzIn/JXfhJ+a2zAtmJD/oWMRoJaB4oCdV1Ehm1+VYzz6a4Ex1gBIke6HdY
         +nl1OQeN2pIXr9mfkEez5NitJIhcJGwA0YByk=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 15/45] kstrtox: convert drivers/block/
Date: Sun,  5 Dec 2010 19:49:12 +0200
Message-Id: <1291571382-2719-15-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/block/osdblk.c |   10 ++--------
 drivers/block/rbd.c    |    8 +-------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 87311eb..9a645ed 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -596,18 +596,12 @@ static ssize_t class_osdblk_remove(struct class *c,
 {
 	struct osdblk_device *osdev = NULL;
 	int target_id, rc;
-	unsigned long ul;
 	struct list_head *tmp;
 
-	rc = strict_strtoul(buf, 10, &ul);
-	if (rc)
+	rc = kstrtoint(buf, 10, &target_id);
+	if (rc < 0)
 		return rc;
 
-	/* convert to int; abort if we lost anything in the conversion */
-	target_id = (int) ul;
-	if (target_id != ul)
-		return -EINVAL;
-
 	/* remove object from list immediately */
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 008d4a0..e3baf92 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1855,18 +1855,12 @@ static ssize_t rbd_remove(struct bus_type *bus,
 {
 	struct rbd_device *rbd_dev = NULL;
 	int target_id, rc;
-	unsigned long ul;
 	int ret = count;
 
-	rc = strict_strtoul(buf, 10, &ul);
+	rc = kstrtoint(buf, 10, &target_id);
 	if (rc)
 		return rc;
 
-	/* convert to int; abort if we lost anything in the conversion */
-	target_id = (int) ul;
-	if (target_id != ul)
-		return -EINVAL;
-
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
 	rbd_dev = __rbd_get_dev(target_id);
-- 
1.7.2.2

