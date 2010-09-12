Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0ILLLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:11:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52496 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0ILLLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=QbDNWIMNLAsWBMGo+PJTXH1U8zXopgKiz0Vy9wqwoab/QZbxmxou7Y47E92Zqk9/EL
         vs8i6il7k64LZSeaM7bgpVVlloXD72spWBzowchSd+8ECYImK/BIh4EZvDINfdwDWUA+
         83XCldN55BrZcpfMAktw5nbVUMKdD/slPeSQk=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        autofs@linux.kernel.org
Subject: [PATCH 1/2] autofs4: fix compilation warning
Date: Sun, 12 Sep 2010 14:10:28 +0300
Message-Id: <1284289829-25425-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
References: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/autofs4/root.c:31: warning: ‘autofs4_root_compat_ioctl’ declared ‘static’ but never defined

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 fs/autofs4/root.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index cb1bd38..87f22ae 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -28,7 +28,9 @@ static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+#endif
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
-- 
1.7.2.3

