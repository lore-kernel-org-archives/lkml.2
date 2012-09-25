Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2IYHC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:02:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20436 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2IYHCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:02:55 -0400
Date: Tue, 25 Sep 2012 10:02:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/3] remoteproc: snprintf() can return more than was printed
Message-ID: <20120925070251.GC23009@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf() returns the number of characters which would have been
printed if there were enough space.  For example, on the first print if
we fill up the 28 character string then it would return a number more
than 30.  Use scnprintf() instead because that returns the actual number
of characters printed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 10a3825..ea90a56 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -82,7 +82,7 @@ static ssize_t rproc_state_read(struct file *filp, char __user *userbuf,
 
 	state = rproc->state > RPROC_LAST ? RPROC_LAST : rproc->state;
 
-	i = snprintf(buf, 30, "%.28s (%d)\n", rproc_state_string[state],
+	i = scnprintf(buf, 30, "%.28s (%d)\n", rproc_state_string[state],
 							rproc->state);
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, i);
@@ -103,7 +103,7 @@ static ssize_t rproc_name_read(struct file *filp, char __user *userbuf,
 	char buf[100];
 	int i;
 
-	i = snprintf(buf, sizeof(buf), "%.98s\n", rproc->name);
+	i = scnprintf(buf, sizeof(buf), "%.98s\n", rproc->name);
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, i);
 }
