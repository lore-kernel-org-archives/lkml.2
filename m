Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0EQT0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:26:24 -0400
Received: from lazybastard.de ([212.112.238.170]:56262 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0EQT0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:26:21 -0400
Date: Mon, 17 May 2010 21:25:47 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, logfs@logfs.org
Subject: Re: linux-next: Tree for April 28 (logfs)
Message-ID: <20100517192547.GD28003@logfs.org>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au> <20100428085604.0566092a.randy.dunlap@oracle.com> <20100505092020.66a461fa.randy.dunlap@oracle.com> <20100505203548.GI25129@logfs.org> <20100509062010.GA9485@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100509062010.GA9485@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 May 2010 08:20:10 +0200, Ingo Molnar wrote:
> 
> Please post the fix itself as well, i've ran into this and so did others.

Jörn

-- 
ticks = jiffies;
while (ticks == jiffies);
ticks = jiffies;
-- /usr/src/linux/init/main.c

When CONFIG_BLOCK is not enabled:

fs/logfs/super.c:142: error: implicit declaration of function 'bdev_get_queue'
fs/logfs/super.c:142: error: invalid type argument of '->' (have 'int')

Found by Randy Dunlap <randy.dunlap@oracle.com>

Signed-off-by: Joern Engel <joern@logfs.org>
---
 fs/logfs/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/logfs/super.c b/fs/logfs/super.c
index edd9948..2b26938 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -138,10 +138,14 @@ static int logfs_sb_set(struct super_block *sb, void *_super)
 	sb->s_fs_info = super;
 	sb->s_mtd = super->s_mtd;
 	sb->s_bdev = super->s_bdev;
+#ifdef CONFIG_BLOCK
 	if (sb->s_bdev)
 		sb->s_bdi = &bdev_get_queue(sb->s_bdev)->backing_dev_info;
+#endif
+#ifdef CONFIG_MTD
 	if (sb->s_mtd)
 		sb->s_bdi = sb->s_mtd->backing_dev_info;
+#endif
 	return 0;
 }
 
-- 
1.6.6.1

