Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0KHHaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:30:08 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:40073 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025Ab0KHHaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:30:01 -0500
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com
Subject: [PATCH 3/4] fs: Use RCU freeing of inodes via SLAB_DESTROY_BY_RCU
Date: Mon,  8 Nov 2010 18:28:24 +1100
Message-Id: <1289201305-14866-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289201305-14866-1-git-send-email-david@fromorbit.com>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Change the inode caches to use RCU freed inodes via the SLAB_DESTROY_BY_RCU
method. This is the first step in converting the inode hash lookups to use RCU
methods.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/slab.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index dca23c5..1fea5f1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -96,6 +96,7 @@
  * Set the default flags necessary for inode caches manipulated by the VFS.
  */
 #define SLAB_INODE_CACHE	(SLAB_MEM_SPREAD | \
+				 SLAB_DESTROY_BY_RCU | \
 				 SLAB_RECLAIM_ACCOUNT)
 
 /*
-- 
1.7.2.3

