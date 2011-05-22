Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1EVQyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 12:54:31 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41515 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1EVQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 12:54:24 -0400
Date: Sun, 22 May 2011 18:54:21 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: add missing prefetch.h include
Message-ID: <20110522165421.GA2504@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes this build error on s390 and probably other archs as well:

fs/inode.c: In function 'new_inode':
fs/inode.c:894:2: error: implicit declaration of function 'spin_lock_prefetch'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 fs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/inode.c b/fs/inode.c
index 33c963d..05f4fa5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -24,6 +24,7 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include <linux/prefetch.h>
 #include <linux/ima.h>
 #include <linux/cred.h>
 #include "internal.h"
