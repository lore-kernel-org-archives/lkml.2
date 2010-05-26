Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0EZToj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:44:39 -0400
Received: from mx2.netapp.com ([216.240.18.37]:36860 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab0EZTog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:44:36 -0400
X-IronPort-AV: E=Sophos;i="4.53,305,1272870000"; 
   d="scan'208";a="368117570"
Subject: [GIT PULL] Please pull NFS client bugfixes...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Wed, 26 May 2010 15:42:21 -0400
Message-ID: <1274902941.5270.36.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
X-OriginalArrivalTime: 26 May 2010 19:44:35.0909 (UTC) FILETIME=[DEDEC750:01CAFD0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "bugfixes" branch of the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git bugfixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/dir.c          |    1 +
 fs/nfs/write.c        |   20 ++++++++++++++++----
 net/sunrpc/xprtsock.c |   29 ++++++++++++++++++-----------
 3 files changed, 35 insertions(+), 15 deletions(-)

commit 0522f6adedd2736cbca3c0e16ca51df668993eee
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed May 26 08:42:24 2010 -0400

    NFS: Fix another nfs_wb_page() deadlock
    
    J.R. Okajima reports that the call to sync_inode() in nfs_wb_page() can
    deadlock with other writeback flush calls. It boils down to the fact
    that we cannot ever call writeback_single_inode() while holding a page
    lock (even if we do set nr_to_write to zero) since another process may
    already be waiting in the call to do_writepages(), and so will deny us
    the I_SYNC lock.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c5efa5fc91f1f6d1d47e65f39e7ec6d1157c777d
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed May 26 08:42:11 2010 -0400

    NFS: Ensure that we mark the inode as dirty if we exit early from commit
    
    If we exit from nfs_commit_inode() without ensuring that the COMMIT rpc
    call has been completed, we must re-mark the inode as dirty. Otherwise,
    future calls to sync_inode() with the WB_SYNC_ALL flag set will fail to
    ensure that the data is on the disk.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 59844a9bd73e084b0ffefc0e13226098e28c71ad
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed May 26 08:42:24 2010 -0400

    NFS: Fix a lock imbalance typo in nfs_access_cache_shrinker
    
    Commit 9c7e7e23371e629dbb3b341610a418cdf1c19d91 (NFS: Don't call iput() in
    nfs_access_cache_shrinker) unintentionally removed the spin unlock for the
    inode->i_lock.
    
    Reported-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0a68b0bed08eeb7ec62e0125f17856b1ccb1ea4b
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Wed May 26 08:42:24 2010 -0400

    sunrpc: fix leak on error on socket xprt setup
    
    Also collect exit code together while we're at it.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>


