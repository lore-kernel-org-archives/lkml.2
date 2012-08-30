Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2H3PCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:02:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60937 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2H3PCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:02:49 -0400
Message-ID: <503F7F0B.4040506@gmail.com>
Date: Thu, 30 Aug 2012 16:56:11 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] exofs: drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lock/unlock super.

Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/exofs/super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index dde41a7..c4360b5 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -384,8 +384,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 	if (unlikely(ret))
 		goto out;
 
-	lock_super(sb);
-
 	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
 	memset(fscb, 0, ios->length);
 	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
@@ -401,8 +399,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 	if (unlikely(ret))
 		EXOFS_ERR("%s: ore_write failed.\n", __func__);
 
-
-	unlock_super(sb);
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
 	ore_put_io_state(ios);
-- 
1.7.3.4
