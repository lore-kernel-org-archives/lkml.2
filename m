Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1ATOzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:55:25 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:56314 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755690Ab1ATOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:55:21 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 09:55:21 EST
Subject: [PATCH] init: return proper error code in do_mounts_rd
From: Davidlohr Bueso <dave@gnu.org>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 11:55:12 -0300
Message-ID: <1295535312.2089.3.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

In do_mounts_rd() if memory cannot be allocated, return -ENOMEM.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 init/do_mounts_rd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 6e1ee69..fe9acb0 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -64,7 +64,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
-		return -1;
+		return -ENOMEM;
 
 	minixsb = (struct minix_super_block *) buf;
 	ext2sb = (struct ext2_super_block *) buf;
-- 
1.7.1



