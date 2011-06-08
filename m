Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1FHQgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:36:37 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:52559 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab1FHQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:36:36 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Lee Jones <lee.jones@linaro.org>, Jonas Aberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] fs/fat: fix build warning
Date: Wed, 8 Jun 2011 18:36:03 +0200
Message-ID: <1307550963-26352-1-git-send-email-linus.walleij@stericsson.com>
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
v2: use uninitialized_var() macro, this is verified to work with
static code-checking tools.
---
 fs/fat/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 4ad6473..5efbd5d 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1231,7 +1231,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	struct super_block *sb = dir->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
-	struct msdos_dir_entry *de;
+	struct msdos_dir_entry *uninitialized_var(de);
 	int err, free_slots, i, nr_bhs;
 	loff_t pos, i_pos;
 
-- 
1.7.3.2

