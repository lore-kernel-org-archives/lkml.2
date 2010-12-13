Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0LMNRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51395 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab0LMNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r1pE1DqLjBGB9A2C74GBce5ikPF6+Tn2pepGGstDxMIE0gVi6+A8kAtndeNiJAC7Go
         Kd4N1xqfCORHq8czPOJCe2uIHzlAXDcS6uBhAMnrhQ/fnP8sPh02VtHeb/zwLvPbaudd
         33zhHRrp30wqb1CIEPcpIlYAD3XKNcdvc2YM8=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Staging: vme_bridge: mark vme_master_resource->kern_base as __iomem
Date: Mon, 13 Dec 2010 22:16:30 +0900
Message-Id: <1292246196-2332-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vme_master_resource->kern_base is mapped by ioremap_nocache()
thus should be marked as __iomem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    4 ++--
 drivers/staging/vme/vme_bridge.h           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index cb72a5d1eeca..a9ce1810bd94 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -851,7 +851,7 @@ ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
 	ssize_t retval;
-	void *addr = image->kern_base + offset;
+	void __iomem *addr = image->kern_base + offset;
 	unsigned int done = 0;
 	unsigned int count32;
 
@@ -911,7 +911,7 @@ ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
 	ssize_t retval;
-	void *addr = image->kern_base + offset;
+	void __iomem *addr = image->kern_base + offset;
 	unsigned int done = 0;
 	unsigned int count32;
 
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index b653ec02e1fc..4c6ec31b01db 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -20,7 +20,7 @@ struct vme_master_resource {
 	vme_cycle_t cycle_attr;
 	vme_width_t width_attr;
 	struct resource bus_resource;
-	void *kern_base;
+	void __iomem *kern_base;
 };
 
 struct vme_slave_resource {
-- 
1.7.3.3.400.g93cef

