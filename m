Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1EXTya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab1EXTy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:54:29 -0400
Date: Tue, 24 May 2011 15:53:56 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.40
Message-ID: <20110524195356.GB27093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.40 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

The most useful patch makes posix lock operations (from gfs2/ocfs2)
interruptible using the helpful wait_event_killable.  This is followed by
a new timer that can be set to warn when locks have been waiting for a
reply message for a configured time.  People debugging lost dlm messages
have been asking for this.
Thanks,
Dave

David Teigland (3):
      dlm: delayed reply message warning
      dlm: remove shared message stub for recovery
      dlm: make plock operation killable

Matt Fleming (1):
      dlm: Remove superfluous call to recalc_sigpending()

 fs/dlm/config.c           |    9 ++-
 fs/dlm/config.h           |    1 +
 fs/dlm/dlm_internal.h     |    3 +
 fs/dlm/lock.c             |  182 +++++++++++++++++++++++++++++++++++----------
 fs/dlm/lock.h             |    1 +
 fs/dlm/lockspace.c        |    6 +-
 fs/dlm/plock.c            |   65 +++++++++++++++-
 fs/dlm/user.c             |    1 -
 include/linux/dlm_plock.h |    6 +-
 9 files changed, 223 insertions(+), 51 deletions(-)
