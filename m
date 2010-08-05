Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab0HEGcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:32:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63355 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab0HEGcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FGKtsCufqGphcFwppLt3WaFzp68+UeYuhiB+VAlnLLPiN8imZ6ks0F+WOrBuFPKvPh
         LrwVjps6O6ZVPLpf3darNhjU3/qE9MSiJRWnho2zGUvwbcgdmZcNmiIYbMRhjD/ELswi
         L8ZAZ5loLeOsWsHHQNh6iRwFn8bJkVBzUZ+No=
MIME-Version: 1.0
Date: Thu, 5 Aug 2010 02:32:10 -0400
Message-ID: <AANLkTincu8bt91COjx4_+Xz1XEobiU=gDr1NLeqv1RF0@mail.gmail.com>
Subject: [PATCH] drm_proc: remove the unneeded _name_ variable in function 
	drm_proc_create_files
From: Liu Aleaxander <aleaxander@gmail.com>
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9cb574dfe14541c7b712242e9fafc55419aa1e4f Mon Sep 17 00:00:00 2001
From: Liu Aleaxander <Aleaxander@gmail.com>
Date: Thu, 5 Aug 2010 14:02:52 -0400
Subject: [PATCH] drm_proc: remove the unneeded _name_ variable in
function drm_proc_create_files

The _name_ variable in drm_proc_create_files is misused, since it hasn't been
initialized before using it.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 drivers/gpu/drm/drm_proc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index a9ba6b6..02f5c98 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -96,7 +96,6 @@ int drm_proc_create_files(struct drm_info_list
*files, int count,
        struct drm_device *dev = minor->dev;
        struct proc_dir_entry *ent;
        struct drm_info_node *tmp;
-       char name[64];
        int i, ret;

        for (i = 0; i < count; i++) {
@@ -118,8 +117,8 @@ int drm_proc_create_files(struct drm_info_list
*files, int count,
                ent = proc_create_data(files[i].name, S_IRUGO, root,
                                       &drm_proc_fops, tmp);
                if (!ent) {
-                       DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
-                                 name, files[i].name);
+                       DRM_ERROR("Cannot create /proc/dri/%d/%s\n",
+                                 minor->index, files[i].name);
                        list_del(&tmp->list);
                        kfree(tmp);
                        ret = -1;
-- 
1.7.0.1


-- 
regards
Liu Aleaxander
