Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2IYHFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:05:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48880 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2IYHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:05:36 -0400
Date: Tue, 25 Sep 2012 10:05:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 3/3] remoteproc: return -EFAULT on copy_from_user failure
Message-ID: <20120925070533.GD23009@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_from_user() returns the number of bytes remaining to be copied, but
we want to return an error code here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index ea90a56..157a573 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -161,7 +161,7 @@ rproc_recovery_write(struct file *filp, const char __user *user_buf,
 
 	ret = copy_from_user(buf, user_buf, count);
 	if (ret)
-		return ret;
+		return -EFAULT;
 
 	/* remove end of line */
 	if (buf[count - 1] == '\n')
