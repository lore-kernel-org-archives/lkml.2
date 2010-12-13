Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab0LMNRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41478 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab0LMNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VaWwmdkqrNXhvXzCWQRJxSrpUVpM/ecDhzAWaSS0+AYM3sU1QVqtGsaPg32MlTInu1
         paEUNoGSY9QVSFT+bP7Vt8GTinxIhgUdQ/3EhXAX7ninqDzZ7nlapMyylR3S2e5mzx1E
         /bWKwBzESYSaMSRFYHyCNvPf61+0QQo1X98Zs=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] Staging: vme_ca91cx42: remove unreachable code
Date: Mon, 13 Dec 2010 22:16:32 +0900
Message-Id: <1292246196-2332-4-git-send-email-namhyung@gmail.com>
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
 drivers/staging/vme/bridges/vme_ca91cx42.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index a9ce1810bd94..1052a6d101cd 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -551,8 +551,7 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 		goto err_resource;
 	}
 
-	image->kern_base = ioremap_nocache(
-		image->bus_resource.start, size);
+	image->kern_base = ioremap_nocache(image->bus_resource.start, size);
 	if (image->kern_base == NULL) {
 		dev_err(ca91cx42_bridge->parent, "Failed to remap resource\n");
 		retval = -ENOMEM;
@@ -561,8 +560,6 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 
 	return 0;
 
-	iounmap(image->kern_base);
-	image->kern_base = NULL;
 err_remap:
 	release_resource(&(image->bus_resource));
 err_resource:
-- 
1.7.3.3.400.g93cef

