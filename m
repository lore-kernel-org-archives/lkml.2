Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1COHs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:48:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60462 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab1COHsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:48:53 -0400
Date: Tue, 15 Mar 2011 18:48:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Adamson <andros@netapp.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Dean Hildebrand <dhildeb@us.ibm.com>,
        Fred Isaman <iisaman@citi.umich.edu>, Mike Sager <sager@netapp.com>,
        Fred Isaman <iisaman@netapp.com>,
        Mingyang Guo <guomingyang@nrchpc.ac.cn>,
        Ricardo Labiaga <Ricardo.Labiaga@netapp.com>,
        Tao Guo <guotao@nrchpc.ac.cn>, Andy Adamson <andros@netapp.com>,
        Benny Halevy <bhalevy@panasas.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: build failure after merge of the bkl-config tree
Message-Id: <20110315184845.1a411e67.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

After merging the bkl-config tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/read.c:21:28: error: linux/smp_lock.h: No such file or directory

Caused by commit 64419a9b2093 ("NFSv4.1: generic read") from the nfs tree
interacting with commit 4ba8216cd905 ("BKL: That's all, folks") from the
bkl-config tree.

I couldn't see that this include file was needed, so I applied the patch
below (which Trond could apply to his tree, I am pretty sure).  (I am not
sure why module.h is included either.)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Mar 2011 18:37:09 +1100
Subject: [PATCH] nfs: BKL is no longer needed, so remove the include

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nfs/read.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 4b764c6..7cded2b 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -18,7 +18,6 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 
 #include <asm/system.h>
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
