Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab2LSVTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:19:54 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:40983 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2LSVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:19:47 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] f2fs: add missing #include <linux/prefetch.h>
Date: Wed, 19 Dec 2012 22:19:30 +0100
Message-Id: <1355951970-19720-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k allmodconfig:

fs/f2fs/data.c: In function ‘read_end_io’:
fs/f2fs/data.c:311: error: implicit declaration of function ‘prefetchw’

fs/f2fs/segment.c: In function ‘f2fs_end_io_write’:
fs/f2fs/segment.c:628: error: implicit declaration of function ‘prefetchw’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/7787109/

 fs/f2fs/data.c    |    1 +
 fs/f2fs/segment.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 655aeab..3aa5ce7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -16,6 +16,7 @@
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
+#include <linux/prefetch.h>
 
 #include "f2fs.h"
 #include "node.h"
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8bc1b6f..ca7b5ff 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -12,6 +12,7 @@
 #include <linux/f2fs_fs.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/prefetch.h>
 #include <linux/vmalloc.h>
 
 #include "f2fs.h"
-- 
1.7.0.4

