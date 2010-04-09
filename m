Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0DIXOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:14:11 -0400
Received: from [69.28.251.93] ([69.28.251.93]:35181 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0DIXOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:14:07 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2010 19:14:07 EDT
From: "root" <root@rpx.1wt.eu>
Date: Fri, 9 Apr 2010 15:45:38 -0700
To: <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] MTD: Suppress warnings in inline_map_read()
Message-Id: <fb80b9139bec21ac8bd4ddcec0abeb9c1ad39ad5@localhost.localdomain>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.4.3 -O2 on MIPS32:

drivers/mtd/chips/cfi_util.c: In function 'cfi_qry_present':
include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
include/linux/mtd/map.h:375: note: 'r' was declared here
include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
include/linux/mtd/map.h:375: note: 'r' was declared here

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 include/linux/mtd/map.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index b981b87..74f0277 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -372,7 +372,7 @@ static inline map_word map_word_ff(struct map_info *map)
 
 static inline map_word inline_map_read(struct map_info *map, unsigned long ofs)
 {
-	map_word r;
+	map_word r = { { 0 } };
 
 	if (map_bankwidth_is_1(map))
 		r.x[0] = __raw_readb(map->virt + ofs);
-- 
1.6.3.1

