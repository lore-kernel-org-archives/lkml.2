Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1DRQBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:01:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60336 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1DRQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Tapm8TRh/Nv6K5CS2SMYZLUmrBOHA5j92FfCiPN9ntlp2bcmx1go64eDH8tC9kp/vi
         1L0P1h70NiMNvcvimXOzz3eX0/Ra1f90hjoMY9njL21gBGbqMzfwUb85Fs9MzLnKxPQM
         lonGWvW99uJTVqqm5Cn0vxRYwt0sfIylAIH2U=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 2/6] vfs: export do_splice_direct() to modules
Date: Mon, 18 Apr 2011 18:00:36 +0200
Message-Id: <1303142440-26328-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
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
index 50a5d97..4f2fa05 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1296,6 +1296,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
-- 
1.7.1

