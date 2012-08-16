Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2HPKGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:06:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62508 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2HPKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:06:38 -0400
Message-ID: <502CC4AA.6040702@gmail.com>
Date: Thu, 16 Aug 2012 12:00:10 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/8] exofs: remove lock/unlock super
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Remove lock and unlock super operation.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.6-rc1-orig/fs/exofs/super.c linux-3.6-rc1/fs/exofs/super.c
--- linux-3.6-rc1-orig/fs/exofs/super.c	2012-08-16 09:37:31.000000000 +0200
+++ linux-3.6-rc1/fs/exofs/super.c	2012-08-16 09:45:31.000000000 +0200
@@ -384,8 +384,6 @@ static int exofs_sync_fs(struct super_bl
 	if (unlikely(ret))
 		goto out;
 -	lock_super(sb);
-
 	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
 	memset(fscb, 0, ios->length);
 	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
@@ -403,8 +401,6 @@ static int exofs_sync_fs(struct super_bl
 	else
 		sb->s_dirt = 0;
 -
-	unlock_super(sb);
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
 	ore_put_io_state(ios);
