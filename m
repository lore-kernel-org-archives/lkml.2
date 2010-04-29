Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0D2Ahf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:37:35 -0400
Received: from [69.28.251.93] ([69.28.251.93]:47381 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0D2Ahe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:37:34 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 28 Apr 2010 17:26:01 -0700
Subject: [PATCH] mtd: cfi_cmdset_0002: Fix trivial merge conflict
Message-Id: <02d08adf6882611e6c0121481e70a61d20a10acf@localhost.localdomain>
To: <dwmw2@infradead.org>, <dedekind1@gmail.com>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold's patch changed chip->mutex, once a spinlock, into a
mutex.  This patch applies the same change to cfi_amdstd_reset(), part
of the new reboot notifier code.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index d356827..c16b8ce 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1945,7 +1945,7 @@ static int cfi_amdstd_reset(struct mtd_info *mtd)
 
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(&chip->mutex);
 
 		ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
 		if (!ret) {
@@ -1954,7 +1954,7 @@ static int cfi_amdstd_reset(struct mtd_info *mtd)
 			put_chip(map, chip, chip->start);
 		}
 
-		spin_unlock(chip->mutex);
+		mutex_unlock(&chip->mutex);
 	}
 
 	return 0;
-- 
1.6.3.1

