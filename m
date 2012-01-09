Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2AIWFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:05:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412Ab2AIWFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:05:51 -0500
Date: Mon, 9 Jan 2012 17:05:47 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.3
Message-ID: <20120109220547.GE9956@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 3.3 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git for-linus

These went into -next before the holidays.  The patches add a major
feature to allow gfs2 to coordinate recovery and keep track of mounted
nodes via the dlm, rather than going out to a separate userland daemon.
I've dropped the gfs2 patch from this series so Steve Whitehouse can take
that via his gfs2 tree.

Thanks,
Dave


Bob Peterson (1):
      dlm: convert rsb list to rb_tree

David Teigland (3):
      dlm: move recovery barrier calls
      dlm: add node slots and generation
      dlm: add recovery callbacks


 fs/dlm/config.c       |  130 ++++++++------
 fs/dlm/config.h       |   17 ++-
 fs/dlm/debug_fs.c     |   28 ++--
 fs/dlm/dir.c          |    1 -
 fs/dlm/dlm_internal.h |   60 +++++-
 fs/dlm/lock.c         |   87 +++++++--
 fs/dlm/lockspace.c    |   71 +++++---
 fs/dlm/member.c       |  486 +++++++++++++++++++++++++++++++++++++++++--------
 fs/dlm/member.h       |   10 +-
 fs/dlm/rcom.c         |   99 +++++++++--
 fs/dlm/rcom.h         |    2 +-
 fs/dlm/recover.c      |   87 +++++++--
 fs/dlm/recoverd.c     |   53 +++---
 fs/dlm/user.c         |    5 +-
 fs/gfs2/lock_dlm.c    |    4 +-
 fs/ocfs2/stack_user.c |    4 +-
 include/linux/dlm.h   |   71 +++++++-
 17 files changed, 943 insertions(+), 272 deletions(-)
