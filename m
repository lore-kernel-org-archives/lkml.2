Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2EVURr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:17:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab2EVURp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:17:45 -0400
Date: Tue, 22 May 2012 16:17:42 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, swhiteho@redhat.com
Subject: [GIT PULL] dlm updates for 3.5
Message-ID: <20120522201742.GD15059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.5

This set includes some minor fixes and improvements.
The one large patch addresses the special "nodir" mode,
which has been a long neglected proof of concept, but
with these fixes seems to be quite usable.  It allows
the resource master to be assigned statically instead of
dynamically, which can improve performance if there is
little locality and most resources are shared.

Thanks,
Dave

Dan Carpenter (1):
      dlm: NULL dereference on failure in kmem_cache_create()

David Teigland (7):
      dlm: prevent connections during shutdown
      dlm: fix waiter recovery
      dlm: limit rcom debug messages
      dlm: avoid unnecessary search in search_rsb
      dlm: improve error and debug messages
      dlm: fixes for nodir mode
      gfs2: fix recovery during unmount

 fs/dlm/ast.c          |    3 +-
 fs/dlm/dlm_internal.h |   16 +-
 fs/dlm/lock.c         |  541 +++++++++++++++++++++++++++++++++----------------
 fs/dlm/lock.h         |    7 +-
 fs/dlm/lockspace.c    |   20 ++
 fs/dlm/lowcomms.c     |   28 ++-
 fs/dlm/memory.c       |    8 +-
 fs/dlm/rcom.c         |   61 +++---
 fs/dlm/recover.c      |   73 ++++---
 fs/dlm/recoverd.c     |   15 +-
 fs/dlm/requestqueue.c |   43 ++--
 fs/gfs2/incore.h      |    1 -
 fs/gfs2/lock_dlm.c    |    2 -
 fs/gfs2/ops_fstype.c  |    7 +-
 fs/gfs2/sys.c         |   10 +-
 include/linux/dlm.h   |    1 -
 16 files changed, 538 insertions(+), 298 deletions(-)
