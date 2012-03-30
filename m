Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405Ab2C3Pqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:46:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43908 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091Ab2C3Pog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:44:36 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [RFC PATCH v2 16/21] ext3: add support for .read_iter and .write_iter
Date: Fri, 30 Mar 2012 10:43:43 -0500
Message-Id: <1333122228-13633-17-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F75D4DF.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

ext3 uses the generic .read_iter and .write_iter functions.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 724df69..30447a5 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -58,6 +58,8 @@ const struct file_operations ext3_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
-- 
1.7.9.5

