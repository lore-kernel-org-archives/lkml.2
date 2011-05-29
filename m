Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1E2MTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 08:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1E2MTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 08:19:30 -0400
Date: Sun, 29 May 2011 13:18:58 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>, stable@kernel.org,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.40
Message-ID: <20110529121858.GC27449@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable@kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper patches for inclusion in 2.6.40. 
There are some minor fixes and a small patchset that reduces kcopyd memory
requirements.

Martin K. Petersen (1):
      dm mpath: do not fail paths after integrity errors

Mike Snitzer (1):
      dm table: allow targets to support discards internally

Mikulas Patocka (8):
      dm kcopyd: avoid pointless job splitting
      dm kcopyd: preallocate sub jobs to avoid deadlock
      dm kcopyd: remove superfluous page allocation spinlock
      dm kcopyd: add gfp parm to alloc_pl
      dm kcopyd: alloc pages from the main page allocator
      dm io: use fixed initial mempool size
      dm kcopyd: reserve fewer pages
      dm kcopyd: return client directly and not through a pointer

Milan Broz (1):
      dm table: reject devices without request fns

 drivers/md/dm-io.c              |   27 +-----
 drivers/md/dm-kcopyd.c          |  168 +++++++++++++++++++++++----------------
 drivers/md/dm-log.c             |    3 +-
 drivers/md/dm-mpath.c           |    2 +-
 drivers/md/dm-raid1.c           |   10 +-
 drivers/md/dm-snap-persistent.c |   13 +---
 drivers/md/dm-snap.c            |   10 +--
 drivers/md/dm-table.c           |   23 +++++-
 include/linux/device-mapper.h   |    6 ++
 include/linux/dm-io.h           |    3 +-
 include/linux/dm-kcopyd.h       |    3 +-
 11 files changed, 144 insertions(+), 124 deletions(-)

Thanks,
Alasdair.

