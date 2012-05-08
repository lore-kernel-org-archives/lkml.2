Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2EHDRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:17:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59643 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2EHDRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:17:16 -0400
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Tue,  8 May 2012 11:24:03 +0800
Message-Id: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

Currently, SATA disk fua detection is disabled on default because most of
devices don't support this feature at that time.  With the development of
technology, more and more SATA disks support this feature.  So now we can enable
this detection on default.

Although fua detection is defined as a kernel module parameter, it is too hard
to set its value because it must be loaded and set before system starts up.
That needs to modify initrd file.  So it is inconvenient for administrator who
needs to manage a huge number of servers.

CC: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 drivers/ata/libata-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 23763a1..3627251 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -133,9 +133,9 @@ int atapi_passthru16 = 1;
 module_param(atapi_passthru16, int, 0444);
 MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
 
-int libata_fua = 0;
+int libata_fua = 1;
 module_param_named(fua, libata_fua, int, 0444);
-MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
+MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
 
 static int ata_ignore_hpa;
 module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
-- 
1.7.4.1

