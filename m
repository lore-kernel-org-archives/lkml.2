Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2EZXcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 19:32:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35823 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2EZXct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 19:32:49 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: panto@antoniou-consulting.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] usb: gadget: f_mass_storage: change default value of the removable parameter
Date: Sat, 26 May 2012 16:32:39 -0700
Message-Id: <9f033e3d3b2bcbdbf02253de540174479c0dd945.1338074060.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit changes the default value of the removable module parameter
from “y” to “n”.  This comes with line with file_storag's default and
seems to be a better default.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

Alternatively I can add a warning about the default being changed and
schedule the change for the future.  Dunno if it's worth it.

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f67b453..72116fa 100644
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

