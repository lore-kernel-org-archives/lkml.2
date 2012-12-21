Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2LUIvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:51:35 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:45784 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LUIv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:51:28 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: <linux-nfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] NFS: Fix compile issue with !CONFIG_NFS_FSCACHE
Date: Fri, 21 Dec 2012 14:21:01 +0530
Message-ID: <1356079861-2503-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20121221083305.GB15226@liondog.tnic>
References: <20121221083305.GB15226@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/inode.c: In function `nfs_invalidate_mapping`:
fs/nfs/inode.c:887: error: implicit declaration of function
`nfs_fscache_wait_on_invalidate`

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 fs/nfs/fscache.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 277b027..4ecb766 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -222,6 +222,7 @@ static inline void nfs_readpage_to_fscache(struct inode *inode,
 
 
 static inline void nfs_fscache_invalidate(struct inode *inode) {}
+static inline void nfs_fscache_wait_on_invalidate(struct inode *inode) {}
 
 static inline const char *nfs_server_fscache_state(struct nfs_server *server)
 {
-- 
1.7.4.1

