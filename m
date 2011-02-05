Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1BEO3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:29:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1BEOVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YBb87s81DjCZ1GobtsGn6ohCWnn2uqR3HZP+LWelFJPuXJLWW4E/CGeaaA9vmqNiF6
         E7BT64+olP/g5o5ibU355MM4kOH2kH3S3g8MdRp8Jq90znlN/8Ld6dI7ewYiFh+qxg9v
         ZphKmtTBG5yxUG9HN2tCi4ABLLkH1MpFBGMLQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 13/52] kstrtox: convert drivers/block/
Date: Sat,  5 Feb 2011 16:20:16 +0200
Message-Id: <1296915654-7458-13-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
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
index e1e38b1..ffe969f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1866,18 +1866,12 @@ static ssize_t rbd_remove(struct bus_type *bus,
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
1.7.3.4

