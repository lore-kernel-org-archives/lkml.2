Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162027Ab1FAMsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:48:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63429 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161587Ab1FAMsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kmqnTCqLGDG6cdmHGYWBMQezc/Ib9KPvD1VMq0fBVq4XekQigrk3+s8UjkMDR3mvZr
         SwzxcLdQKywwg42Z58MF2HhJjBUcNkvTzqc41BMU5DyQ6oIanVTDBxc1Yq8VdfjzigtU
         tEkA8EBp8Nw8fYgtrnBbv4jt0lx7XP8UPCxvk=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: [PATCH 2/7] vfs: export do_splice_direct() to modules
Date: Wed,  1 Jun 2011 14:46:15 +0200
Message-Id: <1306932380-10280-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Export do_splice_direct() to modules.  Needed by overlay filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index aa866d3..bd730eb 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1300,6 +1300,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
-- 
1.7.3.4

