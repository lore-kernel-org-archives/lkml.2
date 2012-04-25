Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab2DYMs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:48:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2DYMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 02/16] vfs: do_last(): make exit RCU safe
Date: Wed, 25 Apr 2012 14:44:03 +0200
Message-Id: <1335357857-16416-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow returning from do_last() with LOOKUP_RCU still set on the "out:" and
"exit:" labels.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fcd807a..020a62f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2385,7 +2385,7 @@ common:
 out:
 	if (want_write)
 		mnt_drop_write(nd->path.mnt);
-	path_put(&nd->path);
+	terminate_walk(nd);
 	return filp;
 
 exit_mutex_unlock:
-- 
1.7.7

