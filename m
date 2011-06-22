Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab1FVPWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:22:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53632 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab1FVPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:22:47 -0400
Message-ID: <4E0208B4.2030107@oracle.com>
Date: Wed, 22 Jun 2011 10:22:28 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110601 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
        "jfs-discussion@lists.sourceforge.net" 
	<jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E0208BE.0013:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/file.c       |    6 +++---
 fs/jfs/jfs_imap.c   |   12 +++++-------
 fs/jfs/jfs_incore.h |    3 ++-
 fs/jfs/resize.c     |    2 +-
 4 files changed, 11 insertions(+), 12 deletions(-)

through these ChangeSets:

commit ecc90462b428db2ad2ee5081c45496ed10f3a633
Author: Dave Kleikamp <dave.kleikamp@oracle.com>
Date:   Mon Jun 20 17:53:24 2011 -0500

    jfs: agstart field must be 64 bits
    
    The previous patch added the agstart field to jfs_ip, but declared
    it a long.  We need to make sure its 64 bits on every platform.
    
    Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

commit d31b53e3cd069e02290ed8a648aa8c7618d6fe77
Author: Dave Kleikamp <dave.kleikamp@oracle.com>
Date:   Mon Jun 20 10:53:46 2011 -0500

    JFS: Don't save agno in the inode
    
    Resizing the file system can result in an in-memory inode being remapped
    to a different aggregate group (AG). A cached AG number can cause
    problems when trying to free or allocate inodes. Instead, save the IAG's
    agstart address and calculate the agno when we need it.
    
    Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 28e0fa894cd5996d3007ce82f07226f79beb7286
Author: Dave Kleikamp <dave.kleikamp@oracle.com>
Date:   Mon Jun 20 10:32:46 2011 -0500

    jfs: Update agstart when resizing volume
    
    A comment indicates that the IAG's agstart does not need to be updated
    since it will always point to a block in the same aggregate group, but
    jfs_fsck isn't so forgiving and reports it as an error.
    
    I'm fixing this in jfsutils as well, so either a new kernel or new
    utilities will be sufficient to fix the problem.
    
    Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 206b6310fd0268a6ca50cf36f03b0f4eee5602ec
Author: Dave Kleikamp <dave.kleikamp@oracle.com>
Date:   Mon Jun 20 10:30:04 2011 -0500

    jfs: old_agsize should be 64 bits in jfs_extendfs
    
    Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
