Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2JFKpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 06:45:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2JFKo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 06:44:58 -0400
Message-ID: <50700A1A.7@gmail.com>
Date: Sat, 06 Oct 2012 12:38:18 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
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
index 59e3bbf..5e59280 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -389,8 +389,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 	if (unlikely(ret))
 		goto out;
 
-	lock_super(sb);
-
 	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
 	memset(fscb, 0, ios->length);
 	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
@@ -406,8 +404,6 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 	if (unlikely(ret))
 		EXOFS_ERR("%s: ore_write failed.\n", __func__);
 
-
-	unlock_super(sb);
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
 	ore_put_io_state(ios);
-- 
1.7.3.4
