Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2HGMpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:45:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58092 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2HGMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:44:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjones@redhat.com, steveamigauk@yahoo.co.uk, mszeredi@suse.cz
Subject: [PATCH 3/4] vfs: pass right create mode to may_o_create()
Date: Tue,  7 Aug 2012 14:45:48 +0200
Message-Id: <1344343549-11887-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
References: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Pass the umask-ed create mode to may_o_create() instead of the original one.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5bac1bb..26c28ec 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2452,7 +2452,7 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 	}
 
 	if (open_flag & O_CREAT) {
-		error = may_o_create(&nd->path, dentry, op->mode);
+		error = may_o_create(&nd->path, dentry, mode);
 		if (error) {
 			create_error = error;
 			if (open_flag & O_EXCL)
-- 
1.7.7

