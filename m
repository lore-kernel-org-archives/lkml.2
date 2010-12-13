Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab0LMNRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57415 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab0LMNRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NBxOLeLZFBTZQMrOn+sH0gwmUdf8QAu49utJesZPLzUE+M9mHuc+AmhM3oIZtE23gn
         qX0K0W0Wo5/Oo+TAffSB5vJ4/23yPrIl529QG44zylgWc8m6/0dVX72BVDmpECksMk5i
         2QctT7S4eMDD8AKjEpDpkcMXkRY7gf30TpPJY=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] Staging: vme_tsi148: remove unreachable code
Date: Mon, 13 Dec 2010 22:16:35 +0900
Message-Id: <1292246196-2332-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iounmap() call and a assignment are could not be executed
because they have no label. Remove them and merge short lines.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_tsi148.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 0ec9fa4768c2..a4c7f206cec6 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -856,8 +856,7 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 		goto err_resource;
 	}
 
-	image->kern_base = ioremap_nocache(
-		image->bus_resource.start, size);
+	image->kern_base = ioremap_nocache(image->bus_resource.start, size);
 	if (image->kern_base == NULL) {
 		dev_err(tsi148_bridge->parent, "Failed to remap resource\n");
 		retval = -ENOMEM;
@@ -866,8 +865,6 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 
 	return 0;
 
-	iounmap(image->kern_base);
-	image->kern_base = NULL;
 err_remap:
 	release_resource(&(image->bus_resource));
 err_resource:
-- 
1.7.3.3.400.g93cef

