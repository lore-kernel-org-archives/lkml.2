Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0DJShf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 14:37:35 -0400
Received: from [69.28.251.93] ([69.28.251.93]:38814 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0DJShe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 14:37:34 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Apr 2010 14:37:33 EDT
From: Kevin Cernekee <cernekee@gmail.com>
Date: Sat, 10 Apr 2010 11:18:58 -0700
To: <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] MTD: Suppress warnings in inline_map_read()
Message-Id: <e970485f0e9f4c9e1cb6e594a45dd11308683197@localhost.localdomain>
References: <1270891582.4704.102.camel@macbook.infradead.org>
In-Reply-To: <1270891582.4704.102.camel@macbook.infradead.org>
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
 include/linux/mtd/map.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index b981b87..56a4592 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -386,6 +386,8 @@ static inline map_word inline_map_read(struct map_info *map, unsigned long ofs)
 #endif
 	else if (map_bankwidth_is_large(map))
 		memcpy_fromio(r.x, map->virt+ofs, map->bankwidth);
+	else
+		BUG();
 
 	return r;
 }
-- 
1.6.3.1

