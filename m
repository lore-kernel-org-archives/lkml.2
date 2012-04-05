Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2DEO7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2DEO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:38 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 02/34] vfs: do_last(): make exit RCU safe
Date: Thu,  5 Apr 2012 16:58:28 +0200
Message-Id: <1333637940-31884-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
index 338410a..dc4003e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2414,7 +2414,7 @@ common:
 out:
 	if (want_write)
 		mnt_drop_write(nd->path.mnt);
-	path_put(&nd->path);
+	terminate_walk(nd);
 	return filp;
 
 exit_mutex_unlock:
-- 
1.7.7

