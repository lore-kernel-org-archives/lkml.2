Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0IXNWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:22:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43005 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0IXNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :mime-version:content-type:content-transfer-encoding;
        b=H6UxO3ojqo9XISOwWR4dVzfm2JnvO+/QGReuKzGn2BTQNkyQ6+FZpiE1L1SILpktLy
         Yg3VR7KDexj7NkVF+9OnbEI7YjMkl6/rvPLO2+9eEpPEF3xSVT12sAM1Lh+LQhhrUKXq
         4BDy/7jN/Cb/LFQ7530wPDy78M/ntMWWpNkY0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT is defined
Date: Fri, 24 Sep 2010 15:22:22 +0200
Message-Id: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The patch solves the following warnings message when CONFIG_COMPAT
is not defined:

fs/autofs/root.c:30: warning: ‘autofs_root_compat_ioctl’ declared ‘static’ but never defined

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/autofs/root.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 11b1ea7..0c4ca81 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -27,7 +27,9 @@ static int autofs_root_unlink(struct inode *,struct dentry *);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
 static int autofs_root_mkdir(struct inode *,struct dentry *,int);
 static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
 static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+#endif
 
 const struct file_operations autofs_root_operations = {
 	.llseek		= generic_file_llseek,
-- 
1.6.2.3

