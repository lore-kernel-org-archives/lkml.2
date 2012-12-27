Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab2L0Oaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:30:39 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:42270 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2L0Oah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:30:37 -0500
Date: Thu, 27 Dec 2012 15:30:32 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] f2fs: add missing pretech.h include
Message-ID: <20121227143032.GA3223@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12122714-6892-0000-0000-000003EAA924
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aa027f06dfb5b2fd27d6f92391d8340df671e82b Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 27 Dec 2012 15:22:27 +0100
Subject: [PATCH] f2fs: add missing pretech.h include

Fix these compile errors on s390:

fs/f2fs/data.c: In function 'read_end_io':
fs/f2fs/data.c:311:4: error: implicit declaration of function 'prefetchw' [-Werror=implicit-function-declaration]
fs/f2fs/segment.c: In function 'f2fs_end_io_write':
fs/f2fs/segment.c:628:4: error: implicit declaration of function 'prefetchw' [-Werror=implicit-function-declaration]

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/f2fs/data.c    | 1 +
 fs/f2fs/segment.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 655aeab..f5d2c62 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -13,6 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
+#include <linux/prefetch.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1b26e4e..cc28975 100644
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
1.7.12.4

