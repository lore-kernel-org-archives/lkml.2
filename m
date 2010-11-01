Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0KAU3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:29:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41763 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0KAU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:29:32 -0400
Date: Tue, 2 Nov 2010 05:29:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: logfs: Fix up MTD=y build.
Message-ID: <20101101202921.GA5085@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7d945a3aa7608f68dba04083d3421e0b43052660 ("logfs get_sb, part 3")
broke the logfs build when CONFIG_MTD is set due to a mangled
logfs_get_sb_mtd() definition.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/logfs/logfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index cd51a36..57afd4a 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -486,7 +486,7 @@ static inline int logfs_get_sb_bdev(struct logfs_super *s,
 
 /* dev_mtd.c */
 #ifdef CONFIG_MTD
-int logfs_get_sb_mtd(struct logfs_super *s, int mtdnr)
+int logfs_get_sb_mtd(struct logfs_super *s, int mtdnr);
 #else
 static inline int logfs_get_sb_mtd(struct logfs_super *s, int mtdnr)
 {
