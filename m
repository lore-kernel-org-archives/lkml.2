Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2FTSby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:31:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab2FTSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:37 -0400
Message-Id: <20120620173025.492912720@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 53/61] remoteproc: fix print format warnings
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

commit e981f6d41acda2ae8c05e60feb2cb97772b4a6e6 upstream.

Fix compile warnings from GCC 4.6.1 when printing values of type size_t.

drivers/remoteproc/remoteproc_core.c:251:6:
warning: format ‘%x’ expects argument of type ‘unsigned int’,
but argument 4 has type ‘size_t’ [-Wformat]
drivers/remoteproc/remoteproc_core.c:938:9:
warning: format ‘%u’ expects argument of type ‘unsigned int’,
but argument 4 has type ‘size_t’ [-Wformat]
drivers/remoteproc/remoteproc_core.c:1023:2:
warning: format ‘%d’ expects argument of type ‘int’,
but argument 4 has type ‘size_t’ [-Wformat]

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -247,7 +247,7 @@ rproc_load_segments(struct rproc *rproc,
 		}
 
 		if (offset + filesz > len) {
-			dev_err(dev, "truncated fw: need 0x%x avail 0x%x\n",
+			dev_err(dev, "truncated fw: need 0x%x avail 0x%zx\n",
 					offset + filesz, len);
 			ret = -EINVAL;
 			break;
@@ -934,7 +934,7 @@ static void rproc_resource_cleanup(struc
 		unmapped = iommu_unmap(rproc->domain, entry->da, entry->len);
 		if (unmapped != entry->len) {
 			/* nothing much to do besides complaining */
-			dev_err(dev, "failed to unmap %u/%u\n", entry->len,
+			dev_err(dev, "failed to unmap %u/%zu\n", entry->len,
 								unmapped);
 		}
 
@@ -1020,7 +1020,7 @@ static int rproc_fw_boot(struct rproc *r
 
 	ehdr = (struct elf32_hdr *)fw->data;
 
-	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
+	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
 	/*
 	 * if enabling an IOMMU isn't relevant for this rproc, this is


