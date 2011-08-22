Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1HVKIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:08:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53827 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1HVKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:08:34 -0400
Date: Mon, 22 Aug 2011 13:08:24 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Bryan Freed <bfreed@chromium.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: industrialio-core: Fix compiler warning
Message-ID: <20110822100824.GA6671@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/iio/industrialio-core.c: In function
'iio_device_add_event_sysfs':
drivers/staging/iio/industrialio-core.c:914: warning: 'mask' may be
used uninitialized in this function

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 19819e7..83b5953 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -911,7 +911,7 @@ static int iio_device_add_event_sysfs(struct iio_dev *dev_info,
 				      struct iio_chan_spec const *chan)
 {
 
-	int ret = 0, i, mask;
+	int ret = 0, i, mask = 0;
 	char *postfix;
 	if (!chan->event_mask)
 		return 0;
@@ -944,6 +944,8 @@ static int iio_device_add_event_sysfs(struct iio_dev *dev_info,
 			break;
 		default:
 			printk(KERN_INFO "currently unhandled type of event\n");
+			ret = -EINVAL;
+			goto error_ret;
 		}
 		ret = __iio_add_chan_devattr(postfix,
 					     NULL,
