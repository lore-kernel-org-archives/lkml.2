Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1E3Tuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:50:39 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:45599 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1E3Tui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:50:38 -0400
Message-ID: <4DE3F502.7060202@freemail.hu>
Date: Mon, 30 May 2011 21:50:26 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbip: change dev_attr_group to constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.98.223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The dev_attr_group variable is never changed and it is only passed
to the second parameter of sysfs_create_group() and sysfs_remove_group() functions.
These functions are defined in linux/sysfs.h: the second parameter is a pointer to
const in both cases.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index d5bc8e7..a208ef0 100644
--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -105,7 +105,7 @@ struct vhci_hcd {
 };

 extern struct vhci_hcd *the_controller;
-extern struct attribute_group dev_attr_group;
+extern const struct attribute_group dev_attr_group;
 #define hardware (&the_controller->pdev.dev)

 /* vhci_hcd.c */
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index d9736f9..0cd039b 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -239,6 +239,6 @@ static struct attribute *dev_attrs[] = {
 	NULL,
 };

-struct attribute_group dev_attr_group = {
+const struct attribute_group dev_attr_group = {
 	.attrs = dev_attrs,
 };
