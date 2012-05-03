Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2ECO5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:57:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41032 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2ECO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:57:12 -0400
Message-ID: <1336057018.4205.2.camel@phoenix>
Subject: [PATCH] IIO: industrialio-core: Checking NULL instead of IS_ERR for
 debugfs_create_dir()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 03 May 2012 22:56:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If defined CONFIG_DEBUG_FS, debugfs_create_dir returns NULL on failure.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/iio/industrialio-core.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 72e33b8..c74412b 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -235,15 +235,12 @@ static int iio_device_register_debugfs(struct iio_dev *indio_dev)
 	if (indio_dev->info->debugfs_reg_access == NULL)
 		return 0;
 
-	if (IS_ERR(iio_debugfs_dentry))
+	if (!iio_debugfs_dentry)
 		return 0;
 
 	indio_dev->debugfs_dentry =
 		debugfs_create_dir(dev_name(&indio_dev->dev),
 				   iio_debugfs_dentry);
-	if (IS_ERR(indio_dev->debugfs_dentry))
-		return PTR_ERR(indio_dev->debugfs_dentry);
-
 	if (indio_dev->debugfs_dentry == NULL) {
 		dev_warn(indio_dev->dev.parent,
 			 "Failed to create debugfs directory\n");
-- 
1.7.5.4



