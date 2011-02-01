Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1BAWCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:02:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1BAWCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:02:37 -0500
Date: Tue, 1 Feb 2011 16:41:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/4] hfsplus: Don't leak buffer on error
Message-ID: <20110201164155.1a4c9ff6@katamari>
In-Reply-To: <20110201162802.2dd07201@katamari>
References: <20110201162802.2dd07201@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus: Don't leak buffer on error

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.38-rc2-git9.orig/fs/hfsplus/part_tbl.c
+++ vanilla-2.6.38-rc2-git9/fs/hfsplus/part_tbl.c
@@ -134,7 +134,7 @@ int hfs_part_find(struct super_block *sb
 	res = hfsplus_submit_bio(sb->s_bdev, *part_start + HFS_PMAP_BLK,
 				 data, READ);
 	if (res)
-		return res;
+		goto out;
 
 	switch (be16_to_cpu(*((__be16 *)data))) {
 	case HFS_OLD_PMAP_MAGIC:
@@ -147,7 +147,7 @@ int hfs_part_find(struct super_block *sb
 		res = -ENOENT;
 		break;
 	}
-
+out:
 	kfree(data);
 	return res;
 }
