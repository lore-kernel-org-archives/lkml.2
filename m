Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2GYUzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2GYUzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:55:20 -0400
Date: Wed, 25 Jul 2012 16:55:00 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.6
Message-ID: <20120725205500.GD11597@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.6

This set includes a major redesign of recording the master node for
resources.  The old dir hash table, which just held the master node for
each resource, has been removed.  The rsb hash table has always duplicated
the master node value from the dir, and is now the single record of it.

Having two full hash tables of all resources has always been a waste,
especially since one just duplicated a single value from the other.
Local requests will now often require one instead of two lengthy hash
table searches.

The other substantial change is made possible by the dirtbl removal, and
fixes a long standing race between resource removal and lookup by
reworking how removal is done.  At the same time it improves the
efficiency of removal by avoiding repeated searches through a hash bucket.

The other commits include minor fixes and changes.

Thanks,
Dave

David Teigland (6):
      dlm: use rsbtbl as resource directory
      dlm: use idr instead of list for recovered rsbs
      dlm: fix race between remove and lookup
      dlm: use wait_event_timeout
      dlm: fix conversion deadlock from recovery
      dlm: fix missing dir remove

 fs/dlm/config.c       |    7 -
 fs/dlm/config.h       |    1 -
 fs/dlm/debug_fs.c     |  103 +++-
 fs/dlm/dir.c          |  287 +++--------
 fs/dlm/dir.h          |    7 +-
 fs/dlm/dlm_internal.h |   62 ++-
 fs/dlm/lock.c         | 1292 ++++++++++++++++++++++++++++++++++++++++---------
 fs/dlm/lock.h         |    5 +-
 fs/dlm/lockspace.c    |   45 +-
 fs/dlm/rcom.c         |  147 ++++--
 fs/dlm/rcom.h         |    1 +
 fs/dlm/recover.c      |  295 +++++++----
 fs/dlm/recover.h      |    2 +-
 fs/dlm/recoverd.c     |   14 +-
 14 files changed, 1600 insertions(+), 668 deletions(-)

