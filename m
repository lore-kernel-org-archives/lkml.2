Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0G1MMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:12:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab0G1MMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:12:30 -0400
Date: Wed, 28 Jul 2010 14:13:53 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 3/3] USB: gadget: storage_common: fixed warning building mass
 storage function
In-reply-to: <7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Message-id: <d7a11c97d1b28c7a0336c747de57a9a17dcc7604.1280316431.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
 <7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "nofua" attribute is used in the File-Storage Gadget but the
functions handling it are defined in storage_common.c (which may be
not a bad thing if anyone will want to port tho "nofua" attribute to
mass storage function) which causes the following warnings:

drivers/usb/gadget/storage_common.c:718: \
  warning: ‘fsg_show_nofua’ defined but not used
drivers/usb/gadget/storage_common.c:782: \
  warning: ‘fsg_store_nofua’ defined but not used

Adding __maybe_unused fixes this issue.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/usb/gadget/storage_common.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 484acfb..3379cc3 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -715,8 +715,8 @@ static ssize_t fsg_show_ro(struct device *dev, struct device_attribute *attr,
 				  : curlun->initially_ro);
 }
 
-static ssize_t fsg_show_nofua(struct device *dev, struct device_attribute *attr,
-			      char *buf)
+static ssize_t __maybe_unused
+fsg_show_nofua(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 
@@ -779,9 +779,9 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
-static ssize_t fsg_store_nofua(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
+static ssize_t __maybe_unused
+fsg_store_nofua(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
 {
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 	unsigned long	nofua;
-- 
1.7.1

