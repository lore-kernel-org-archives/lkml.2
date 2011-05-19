Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1ESVDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:03:51 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:38942 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab1ESVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:03:50 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Lee Jones <lee.jones@linaro.org>, Jonas Aberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] fs/fat: fix build warning
Date: Thu, 19 May 2011 23:03:33 +0200
Message-ID: <1305839013-31909-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aberg <jonas.aberg@stericsson.com>

This fixes a compile warning (unititialized variable) in
the fat filesystem code.

Signed-off-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/fat/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index ee42b9e..aace9be 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1229,7 +1229,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	struct super_block *sb = dir->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
-	struct msdos_dir_entry *de;
+	struct msdos_dir_entry *de = NULL;
 	int err, free_slots, i, nr_bhs;
 	loff_t pos, i_pos;
 
-- 
1.7.3.2

