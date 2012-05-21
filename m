Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2EUPf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:35:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65374 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2EUPaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 02/16] vfs: do_last(): make exit RCU safe
Date: Mon, 21 May 2012 17:30:06 +0200
Message-Id: <1337614220-6174-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
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
index b11fcb2..d55ef9e 100644
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

