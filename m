Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0IXNWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:22:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43005 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0IXNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references:mime-version:content-type
         :content-transfer-encoding;
        b=nFL3b0qvrQnkkOOUrN7N0/rQtNlRIRtQ+YfGKeGXjtDPanItBq8RNQfbjnXT5XcLTo
         WKziFJzFGa2lStwojWe/iRQwEwMEMfV5zGk9Tunsa8zyz8TjdVdc5X4pkEKj57JnmJwB
         tM5joclAki0cBPPSI0GRflN4AL/sF9fdYTgxY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ian Kent <raven@themaw.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] autofs4: Only declare function when CONFIG_COMPAT is defined
Date: Fri, 24 Sep 2010 15:22:23 +0200
Message-Id: <1285334543-7074-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Contreras <felipe.contreras@gmail.com>

The patch solves the following warnings message when CONFIG_COMPAT
is not defined:

fs/autofs4/root.c:31: warning: ‘autofs4_root_compat_ioctl’ declared ‘static’ but never defined

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Ian Kent <raven@themaw.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3

