Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2JWDCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:02:36 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34947 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JWDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:02:34 -0400
Message-ID: <508608C6.7050605@gmail.com>
Date: Tue, 23 Oct 2012 07:02:30 +0400
From: Max Filippov <jcmvbkbc@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 07/16 v2] f2fs: add segment operations
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com> <001701cdb0c6$21c2a530$6547ef90$%kim@samsung.com>
In-Reply-To: <001701cdb0c6$21c2a530$6547ef90$%kim@samsung.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Building f2fs for ARM gives the following error:

  CC      fs/f2fs/segment.o
  CC      fs/f2fs/recovery.o
fs/f2fs/segment.c: In function 'build_sit_info':
fs/f2fs/segment.c:1399:2: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
fs/f2fs/segment.c:1399:18: warning: assignment makes pointer from integer without a cast [enabled by default]
fs/f2fs/segment.c:1419:22: warning: assignment makes pointer from integer without a cast [enabled by default]
fs/f2fs/segment.c: In function 'destroy_sit_info':
fs/f2fs/segment.c:1777:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

The following fixes that:

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 57d0931..5bab838 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -12,6 +12,7 @@
 #include <linux/f2fs_fs.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/vmalloc.h>

 #include "f2fs.h"
 #include "segment.h"

-- 
Thanks.
-- Max
