Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0DSLkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:40:09 -0400
Received: from lazybastard.de ([212.112.238.170]:44731 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab0DSLkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:40:06 -0400
Date: Mon, 19 Apr 2010 13:39:53 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100419113952.GB4145@logfs.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100419102056.GS27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 April 2010 12:20:56 +0200, Jens Axboe wrote:
> 
> Care to send your jffs2 patch separately to David? Then I'll commit a
> modified variant for complaining about missing ->s_bdi on mount.

Sure.

David, this patch is untested.  It looks trivially correct and fixes a
nasty bug, but I don't test jffs2 and only noticed the problem in
passing.

Jörn

-- 
Maintenance in other professions and of other articles is concerned with
the return of the item to its original state; in Software, maintenance
is concerned with moving an item away from its original state.
-- Les Belady

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index af8b42e..7c00319 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -44,6 +45,7 @@ static int get_sb_mtd_set(struct super_block *sb, void *_mtd)
 
 	sb->s_mtd = mtd;
 	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, mtd->index);
+	sb->s_bdi = mtd->backing_dev_info;
 	return 0;
 }
 
