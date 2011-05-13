Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab1EMUXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:23:52 -0400
Received: from mx2.netapp.com ([216.240.18.37]:57684 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab1EMUXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:23:51 -0400
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="547834118"
Subject: [GIT PULL] Please pull NFS client bugfixes
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Fri, 13 May 2011 16:23:42 -0400
Message-ID: <1305318222.27980.1.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 13 May 2011 20:23:46.0859 (UTC) FILETIME=[A98D47B0:01CC11AB]
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
 fs/nfs/nfs4filelayout.c    |   27 ++++++++++++++++-----------
 fs/nfs/nfs4filelayout.h    |    2 +-
 fs/nfs/nfs4filelayoutdev.c |   34 +++++++++++++++++-----------------
 fs/nfs/nfs4proc.c          |    6 ++++++
 fs/nfs/pnfs.c              |   34 ++++++++++++++++++++--------------
 fs/nfs/pnfs.h              |    6 +++---
 fs/nfs/read.c              |    4 ++--
 fs/nfs/write.c             |    4 ++--
 include/linux/nfs_xdr.h    |    1 +
 9 files changed, 68 insertions(+), 50 deletions(-)

commit a75b9df9d3bfc3cd1083974c045ae31ce5f3434f
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed May 11 18:00:51 2011 -0400

    NFSv4.1: Ensure that layoutget uses the correct gfp modes
    
    Currently, writebacks may end up recursing back into the filesystem due to
    GFP_KERNEL direct reclaims in the pnfs subsystem.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2887fe45522843149ccf72e01f43813be4fb36c5
Author: Andy Adamson <andros@netapp.com>
Date:   Wed May 11 01:19:58 2011 -0400

    NFSv4.1: remove pnfs_layout_hdr from pnfs_destroy_all_layouts tmp_list
    
    Prevents an infinite loop as list was never emptied.
    
    Signed-off-by: Andy Adamson <andros@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a8a4ae3a899a6c0b4771cc57884800d8b76a6996
Author: Andy Adamson <andros@netapp.com>
Date:   Tue May 3 13:43:03 2011 -0400

    NFSv41: Resend on NFS4ERR_RETRY_UNCACHED_REP
    
    Free the slot and resend the RPC with new session <slot#,seq#>.
    
    For nfs4_async_handle_error, return -EAGAIN and set the task->tk_status to 0
    to restart the async rpc in the rpc_restart_call_prepare state which resets
    the slot.
    
    For nfs4_handle_exception, retrying a call that uses nfs4_call_sync will
    reset the slot via nfs41_call_sync_prepare.
    
    For open/close/lock/locku/delegreturn/layoutcommit/unlink/rename/write
    cachethis is true, so these operations will not trigger an
    NFS4ERR_RETRY_UNCACHED_REP.
    
    Signed-off-by: Andy Adamson <andros@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

