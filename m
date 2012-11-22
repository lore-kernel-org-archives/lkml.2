Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2KVWAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:00:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49608 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab2KVSkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zheng Yan <zheng.z.yan@intel.com>, Alex Elder <elder@inktank.com>
Subject: [ 091/171] rbd: Fix ceph_snap_context size calculation
Date: Wed, 21 Nov 2012 16:40:37 -0800
Message-Id: <20121122004042.490945504@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

(cherry picked from commit f9f9a1904467816452fc70740165030e84c2c659)

ceph_snap_context->snaps is an u64 array

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -497,7 +497,7 @@ static int rbd_header_from_disk(struct r
 
 	snap_count = le32_to_cpu(ondisk->snap_count);
 	header->snapc = kmalloc(sizeof(struct ceph_snap_context) +
-				snap_count * sizeof (*ondisk),
+				snap_count * sizeof(u64),
 				gfp_flags);
 	if (!header->snapc)
 		return -ENOMEM;


