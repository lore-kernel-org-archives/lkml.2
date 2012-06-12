Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2FLKmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:42:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51642 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2FLKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:42:29 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/3] usb: gadget: mass_storage: change default value of the removable parameter
Date: Tue, 12 Jun 2012 12:42:16 +0200
Message-Id: <07016446a43afd5e492946b387627ce2a4a816f3.1339497368.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1339497368.git.mina86@mina86.com>
References: <cover.1339497368.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit changes the default value of the removable module parameter
from “y” to “n”.  This comes with line with file_storag's default and
seems to be a better default.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f67b453..6b6355c 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -124,7 +124,7 @@
  *				backing storage.
  *	ro=b[,b...]	Default false, boolean for read-only access.
  *	removable=b[,b...]
- *			Default true, boolean for removable media.
+ *			Default false, boolean for removable media.
  *	cdrom=b[,b...]	Default false, boolean for whether to emulate
  *				a CD-ROM drive.
  *	nofua=b[,b...]	Default false, booleans for ignore FUA flag
@@ -300,7 +300,7 @@
 /*------------------------------------------------------------------------*/
 
 #define FSG_DRIVER_DESC		"Mass Storage Function"
-#define FSG_DRIVER_VERSION	"2009/09/11"
+#define FSG_DRIVER_VERSION	"2012/05/29"
 
 static const char fsg_string_interface[] = "Mass Storage";
 
@@ -3167,8 +3167,7 @@ fsg_config_from_params(struct fsg_config *cfg,
 	for (i = 0, lun = cfg->luns; i < cfg->nluns; ++i, ++lun) {
 		lun->ro = !!params->ro[i];
 		lun->cdrom = !!params->cdrom[i];
-		lun->removable = /* Removable by default */
-			params->removable_count <= i || params->removable[i];
+		lun->removable = !!params->removable[i];
 		lun->filename =
 			params->file_count > i && params->file[i][0]
 			? params->file[i]
@@ -3203,4 +3202,3 @@ fsg_common_from_params(struct fsg_common *common,
 	fsg_config_from_params(&cfg, params);
 	return fsg_common_init(common, cdev, &cfg);
 }
-
-- 
1.7.7.3

