Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2JZHAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:00:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27933 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2JZHAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:00:49 -0400
Date: Fri, 26 Oct 2012 10:00:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mei: copy_from_user() doesn't return an error code
Message-ID: <20121026070043.GC9284@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_from_user() returns the number of bytes remaining but we should be
returning -EFAULT here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index ed4943f..ce1014e 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -607,8 +607,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	dev_dbg(&dev->pdev->dev, "cb request size = %zd\n", length);
 
-	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
-	if (rets)
+	rets = -EFAULT;
+	if (copy_from_user(write_cb->request_buffer.data, ubuf, length))
 		goto unlock_dev;
 
 	cl->sm_state = 0;
