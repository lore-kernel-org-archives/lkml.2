Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1BKNlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:41:08 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:55017 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab1BKNlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:41:06 -0500
Date: Fri, 11 Feb 2011 08:40:58 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL]
Message-ID: <20110211134058.GA4309@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get regression and bug fixes for 2.6.38.

Thanks,

	       	  	     	      	  - Ted

Curt Wohlgemuth (1):
      ext4: Fix data corruption with multi-block writepages support

Dan Carpenter (1):
      ext4: off by one check in ext4_groupinfo_create_slab()

Eric Sandeen (3):
      ext4: fix panic on module unload when stopping lazyinit thread
      ext4: make grpinfo slab cache names static
      ext4: serialize unaligned asynchronous DIO

Lukas Czerner (1):
      ext4: unregister features interface on module unload

Theodore Ts'o (2):
      ext4: fix up ext4 error handling
      jbd2: call __jbd2_log_start_commit with j_state_lock write locked

 fs/ext4/ext4.h        |    8 ++++
 fs/ext4/extents.c     |   10 +++--
 fs/ext4/file.c        |   60 +++++++++++++++++++++++++++++-
 fs/ext4/mballoc.c     |  100 +++++++++++++++++++++++++++++-------------------
 fs/ext4/page-io.c     |   36 +++++++++--------
 fs/ext4/super.c       |   66 ++++++++++++++++++++++----------
 fs/jbd2/journal.c     |    9 +++-
 fs/jbd2/transaction.c |   21 +++++++---
 8 files changed, 219 insertions(+), 91 deletions(-)
