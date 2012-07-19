Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2GSICz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 04:02:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20895 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2GSICt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 04:02:49 -0400
Date: Thu, 19 Jul 2012 11:02:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] ntfs: remove an unneeded NULL check
Message-ID: <20120719080228.GA13792@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ctx" variable can never be NULL here and also we dereference it
on the previous line.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 7389d2d..4db19f7 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -309,8 +309,7 @@ do_non_resident_extend:
 done:
 	flush_dcache_mft_record_page(ctx->ntfs_ino);
 	mark_mft_record_dirty(ctx->ntfs_ino);
-	if (ctx)
-		ntfs_attr_put_search_ctx(ctx);
+	ntfs_attr_put_search_ctx(ctx);
 	if (m)
 		unmap_mft_record(base_ni);
 	ntfs_debug("Done, initialized_size 0x%llx, i_size 0x%llx.",
