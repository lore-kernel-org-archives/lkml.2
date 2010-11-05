Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0KEDSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:18:10 -0400
Received: from mail.perches.com ([173.55.12.10]:4054 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0KEDIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:40 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/49] drivers/char: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:33 -0700
Message-Id: <e2df01b2f01315465c09e769254e2f33b1a0c7f5.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/agp/backend.c |    3 +--
 drivers/char/mspec.c       |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index f27d0d0..4b71647 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -171,7 +171,7 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	}
 	got_gatt = 1;
 
-	bridge->key_list = vmalloc(PAGE_SIZE * 4);
+	bridge->key_list = vzalloc(PAGE_SIZE * 4);
 	if (bridge->key_list == NULL) {
 		dev_err(&bridge->dev->dev,
 			"can't allocate memory for key lists\n");
@@ -181,7 +181,6 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	got_keylist = 1;
 
 	/* FIXME vmalloc'd memory not guaranteed contiguous */
-	memset(bridge->key_list, 0, PAGE_SIZE * 4);
 
 	if (bridge->driver->configure()) {
 		dev_err(&bridge->dev->dev, "error configuring host chipset\n");
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 966a95b..25d139c 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -271,14 +271,13 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
 	if (vdata_size <= PAGE_SIZE)
-		vdata = kmalloc(vdata_size, GFP_KERNEL);
+		vdata = kzalloc(vdata_size, GFP_KERNEL);
 	else {
-		vdata = vmalloc(vdata_size);
+		vdata = vzalloc(vdata_size);
 		flags = VMD_VMALLOCED;
 	}
 	if (!vdata)
 		return -ENOMEM;
-	memset(vdata, 0, vdata_size);
 
 	vdata->vm_start = vma->vm_start;
 	vdata->vm_end = vma->vm_end;
-- 
1.7.3.1.g432b3.dirty

