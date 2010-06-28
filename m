Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab0F1LTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:19:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46975 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0F1LTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=VvpZkDlsUVNH5eyhzUdFDxwy5HL1i7tqwJCIo9HdIkhOn/xmsJR5jRF4dQ/ddBHIrL
         Vgp4wVjLoKEsbUuESM/aqq6ONvaVo3GSEfW7l6kbRD0o4MSMLneo+6tWSffIYOxiIan4
         0g4u2RFmGiIK2hIkbLs1Xqf5VdDqGVfJKC+eA=
Date: Mon, 28 Jun 2010 13:17:26 +0200
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>, Diego Calleja <diegocg@gmail.com>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: make code reachable in btrfs_insert_some_items()
Message-ID: <20100628111726.GI19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>, Diego Calleja <diegocg@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The break was in front of the "nr = i" assignment so that was never hit.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0d1d966..ceb8ad2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3453,8 +3453,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	for (i = 0; i < nr; i++) {
 		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 		    BTRFS_LEAF_DATA_SIZE(root)) {
-			break;
 			nr = i;
+			break;
 		}
 		total_data += data_size[i];
 		total_size += data_size[i] + sizeof(struct btrfs_item);
