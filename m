Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1ETEmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:42:18 -0400
Received: from [69.28.251.93] ([69.28.251.93]:57630 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1ETEmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:42:17 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: fix missing header file
Date: Thu, 19 May 2011 21:36:13 -0700
Message-Id: <ceb1d5795a2737519036960c9f726cfa@localhost>
In-Reply-To: <bc781b295b38241533a2d90c1aea15b3@localhost>
References: <bc781b295b38241533a2d90c1aea15b3@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_lock_prefetch() requires <linux/prefetch.h>.  This failure was seen
on MIPS:

  CC      fs/inode.o
fs/inode.c: In function 'new_inode':
fs/inode.c:894:2: error: implicit declaration of function 'spin_lock_prefetch'
make[1]: *** [fs/inode.o] Error 1
make: *** [fs] Error 2

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 fs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 33c963d..c77081f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,7 @@
 #include <linux/posix_acl.h>
 #include <linux/ima.h>
 #include <linux/cred.h>
+#include <linux/prefetch.h>
 #include "internal.h"
 
 /*
-- 
1.7.5

