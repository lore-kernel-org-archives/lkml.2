Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab0J2Pvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:51:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60503 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0J2Pvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ms+yf3/hVLUXm1xBmFb/gfBNAvi3PcnT5TorQ/t/Zpnwy9e/khGli1U+fWHYe5UQxu
         K3hO+nJ84+7TY7FpI+e+IKP71dAT25Sfx7aD64gzRCTA9E92nprvevzTX1lSEQNYnR8T
         sWePaxG+e7Va62CM/8w3P9qEuKGMu7OOY2jwg=
From: Chun Wu <chun.wu84@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Chun Wu <chun.wu84@gmail.com>
Subject: [PATCH] block: missing module_put in put_disk
Date: Fri, 29 Oct 2010 11:51:35 -0400
Message-Id: <1288367495-2919-1-git-send-email-chun@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun Wu <chun.wu84@gmail.com>

module_put function is not called in put_disk function. Should it be added?
 
Signed-off-by: Chun Wu <chun.wu84@gmail.com>
---
 block/genhd.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..91299dc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1228,6 +1228,13 @@ EXPORT_SYMBOL(get_disk);
 
 void put_disk(struct gendisk *disk)
 {
+#ifdef CONFIG_MODULE_UNLOAD
+	struct module *owner;
+
+	owner = disk->fops->owner;
+	if (owner)
+		module_put(owner);
+#endif
 	if (disk)
 		kobject_put(&disk_to_dev(disk)->kobj);
 }
-- 
1.5.6.5

