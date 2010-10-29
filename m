Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082Ab0J2WMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:12:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52685 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0J2WMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=O8jaVd1xkIx5ijxRI50O4Vhqp1HH40Pot+xE1lpzKqEmLIXN1aPJfwLD2K/HgnNqRb
         O8waLhlXNgDo2T7guUr86P1WfGWcBrAulRfqLJ8JVI9C58+/eMIZcO1b09e7JvtgNMK+
         Nlaw3O2pvTSmbHtMrN1phvCinE0u4PFP8T6D0=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ecryptfs: fix truncation error in  ecryptfs_read_update_atime
Date: Sat, 30 Oct 2010 00:11:50 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
Cc: jmoyer@redhat.com, hch@lst.de, esandeen@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010300011.51022.edward.shishkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to the bug found in direct-io not so long ago.

Fix up truncation (ssize_t->int).  This only matters with >2G
reads/writes, which the kernel doesn't permit.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/ecryptfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.36.orig/fs/ecryptfs/file.c
+++ linux-2.6.36/fs/ecryptfs/file.c
@@ -48,7 +48,7 @@ static ssize_t ecryptfs_read_update_atim
 				const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
-	int rc;
+	ssize_t rc;
 	struct dentry *lower_dentry;
 	struct vfsmount *lower_vfsmount;
 	struct file *file = iocb->ki_filp;
