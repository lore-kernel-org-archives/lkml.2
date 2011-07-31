Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1GaTkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 15:40:01 -0400
Received: from mx2.netapp.com ([216.240.18.37]:18027 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1GaTjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 15:39:55 -0400
X-IronPort-AV: E=Sophos;i="4.67,296,1309762800"; 
   d="scan'208";a="566954115"
Subject: Re: Please pull NFS client changes
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 31 Jul 2011 15:39:53 -0400
In-Reply-To: <4E35A9B1.9090309@fusionio.com>
References: <1312082377.10882.1.camel@lade.trondhjem.org>
	 <20110731182406.GA16470@infradead.org> <4E35A9B1.9090309@fusionio.com>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1312141193.7127.1.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 31 Jul 2011 19:39:54.0612 (UTC) FILETIME=[9F3E8340:01CC4FB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 21:14 +0200, Jens Axboe wrote: 
> On 2011-07-31 20:24, Christoph Hellwig wrote:
> > How does this manage to include the pnfs block code, which only was posted
> > on the list a few hours before the pull request, and which doesn't
> > appear to past testing very well (although the major issue seems to be
> > core nfs code)?
> 
> And it doesn't even compile:
> 
> In file included from fs/nfs/client.c:51:0:
> fs/nfs/pnfs.h:384:1: error: expected identifier or ‘(’ before ‘{’ token
> fs/nfs/client.c: In function ‘nfs_server_set_fsinfo’:
> fs/nfs/client.c:939:8: error: ‘struct nfs_server’ has no member named
> ‘pnfs_blksize’
> fs/nfs/client.c: At top level:
> fs/nfs/pnfs.h:382:20: warning: ‘set_pnfs_layoutdriver’ used but never
> defined [enabled by default]
> make[2]: *** [fs/nfs/client.o] Error 1

Sigh. This should fix it...
8<------------------------------------------------------------------------------------- 
>From b74e1d98b2027aa3ec46f3612143d0d35db92cf5 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sun, 31 Jul 2011 15:33:26 -0400
Subject: [PATCH] NFS: Fix a typo in fs/nfs/pnfs.h

Reported-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/pnfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index e0b5d80..01cbfd5 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -380,7 +380,7 @@ pnfs_roc_drain(struct inode *ino, u32 *barrier)
 }
 
 static inline void set_pnfs_layoutdriver(struct nfs_server *s,
-					 const struct nfs_fh *mntfh, u32 id);
+					 const struct nfs_fh *mntfh, u32 id)
 {
 }
 
-- 
1.7.6


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

