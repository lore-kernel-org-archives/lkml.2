Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1BERrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:35 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51340 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1BERr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:28 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 17/17] fs/9p: set default readahead pages in cached mode
Date: Sat,  5 Feb 2011 23:16:45 +0530
Message-Id: <1296928005-9529-18-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to enable readahead in cached mode

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 4838a56..cfb8e97 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -86,6 +86,8 @@ v9fs_fill_super(struct super_block *sb, struct v9fs_session_info *v9ses,
 	} else
 		sb->s_op = &v9fs_super_ops;
 	sb->s_bdi = &v9ses->bdi;
+	if (v9ses->cache)
+		sb->s_bdi->ra_pages = (VM_MAX_READAHEAD * 1024)/PAGE_CACHE_SIZE;
 
 	sb->s_flags = flags | MS_ACTIVE | MS_DIRSYNC | MS_NOATIME;
 	if (!v9ses->cache)
-- 
1.7.1

