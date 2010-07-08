Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0GHEmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:42:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54444 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0GHEl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fBAWHkYVS4SSFZxR30f+7Ms8RvzjPsdnjxMQLm45UWSoRIh/4QtMNF7Jjae4h1ttYi
         08fQ3/qTATRvTvF4sFKDo+8YNB3zH4fHESQ2tv13FKH9uE7JOOCZzQwMMJrr2/UFHR3o
         zSljuKftNFw04mKHL4h0Ta2Icli4Z2pLX4PW0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: jack@suse.cz
Cc: hch@lst.de, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]udf:super.c Fix warning: variable 'sbi' set but not used
Date: Wed,  7 Jul 2010 21:42:13 -0700
Message-Id: <1278564133-19682-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes this warning when building the kernel:
  CC      fs/udf/super.o
fs/udf/super.c: In function 'udf_load_sequence':
fs/udf/super.c:1582:22: warning: variable 'sbi' set but not used
Please have a look, when you have time and let me know.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/udf/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 612d1e2..12bb651 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1579,9 +1579,7 @@ static int udf_load_sequence(struct super_block *sb, struct buffer_head *bh,
 {
 	struct anchorVolDescPtr *anchor;
 	long main_s, main_e, reserve_s, reserve_e;
-	struct udf_sb_info *sbi;
 
-	sbi = UDF_SB(sb);
 	anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 	/* Locate the main sequence */
-- 
1.7.1.rc1.21.gf3bd6

