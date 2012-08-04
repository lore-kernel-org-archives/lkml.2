Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2HDECR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:02:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2HDECL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:02:11 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 04/15] firmware loader: fix creation failure of fw loader device
Date: Sat,  4 Aug 2012 12:01:19 +0800
Message-Id: <1344052890-31935-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one device driver calls request_firmware_nowait() to request
several different firmwares' loading, device_add() will return
failure since all firmware loader device use same name of the
device who is requesting firmware.

This patch always use the name of firmware image as the firmware
loader device name to fix the problem since the following patches
for caching firmware will make sure only one loading for same
firmware is alllowd at the same time.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 0bd09c7..04c75b5 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -452,7 +452,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 	f_dev = &fw_priv->dev;
 
 	device_initialize(f_dev);
-	dev_set_name(f_dev, "%s", dev_name(device));
+	dev_set_name(f_dev, "%s", fw_name);
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 
-- 
1.7.9.5

