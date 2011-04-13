Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab1DMPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:00:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48875 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab1DMPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wjWEh8tKwAeFjXgv7VuqSJBDLnk18XtPE2Ptmqp3N2HQbxRAxtG7db0eV1c1yjKD2+
         doDP0VNrgMlOcwglq1O+gT3oke5eaEtGIhTIvu5//LLC5wBtJ6kIbnuTDwq9jcJB1iB/
         2XJGCiOkvwdBZM77dhNGBYFVaw5WiSEXA0jto=
From: Liu Yuan <namei.unix@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] block, blk-sysfs: Use the variable directly instead of a function call
Date: Wed, 13 Apr 2011 22:59:57 +0800
Message-Id: <1302706797-15980-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

In the function blk_register_queue(), var _dev_ is already assigned by
disk_to_dev().So use it directly instead of calling disk_to_dev() again.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 block/blk-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 261c75c..cb52393 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -521,7 +521,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (ret) {
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
-		blk_trace_remove_sysfs(disk_to_dev(disk));
+		blk_trace_remove_sysfs(dev);
 		kobject_put(&dev->kobj);
 		return ret;
 	}
-- 
1.7.1

