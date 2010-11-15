Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab0KOUcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:32:51 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:54393 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758229Ab0KOUct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:32:49 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 5AAA830205
Subject: [PATCH 1/3] HID: fixed typos from last commits regarding sysfs bin
 attr groups
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 21:32:45 +0100
Message-ID: <1289853165.2188.45.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a 'static' where it belongs and changed a function call to use
the right one.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    2 +-
 fs/sysfs/group.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index ccb5724..799dc80 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -695,7 +695,7 @@ exit_1:
 
 static void kone_remove_sysfs_attributes(struct usb_interface *intf)
 {
-	sysfs_remove_group(&intf->dev.kobj, &kone_bin_attribute_group);
+	sysfs_remove_bin_group(&intf->dev.kobj, &kone_bin_attribute_group);
 	sysfs_remove_group(&intf->dev.kobj, &kone_attribute_group);
 }
 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 841baed..7e60e9c 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -167,7 +167,7 @@ void sysfs_remove_bin_group(struct kobject * kobj,
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_group);
 
-int internal_merge_group(struct kobject *kobj,
+static int internal_merge_group(struct kobject *kobj,
 		       const struct attribute_group *grp, int type)
 {
 	struct sysfs_dirent *dir_sd;
-- 
1.7.2.3



