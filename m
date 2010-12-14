Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0LNFz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:55:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53536 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0LNFzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:55:25 -0500
Date: Tue, 14 Dec 2010 16:55:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: linux-next: manual merge of the cleancache tree with the vfs-scale
 tree
Message-Id: <20101214165521.1d67d30b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Today's linux-next merge of the cleancache tree got a conflict in
fs/super.c between commit fb0a35ccc864ca877ed0908abcb7e8d0a5e09858 ("fs:
dcache per-bucket dcache hash locking") from the vfs-scale tree and
commit 03e838947c8abe29a9d7abfaf7fd9125a46b70e9 ("mm/fs: add hooks to
support cleancache") from the cleancache tree.

Just trivial overlapping additions.  I fixed it up (see below) and can
carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/super.c
index 968ba01,30a54e0..0000000
--- a/fs/super.c
+++ b/fs/super.c
@@@ -30,7 -30,7 +30,8 @@@
  #include <linux/idr.h>
  #include <linux/mutex.h>
  #include <linux/backing-dev.h>
 +#include <linux/rculist_bl.h>
+ #include <linux/cleancache.h>
  #include "internal.h"
  
  
