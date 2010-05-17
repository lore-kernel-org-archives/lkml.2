Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0EQRTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:19:49 -0400
Received: from lazybastard.de ([212.112.238.170]:57760 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0EQRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:19:48 -0400
Date: Mon, 17 May 2010 19:19:29 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Please pull logfs tree for fixes
Message-ID: <20100517171929.GC28003@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

this should have made it into 2.6.34 - except that I was on vacation
last week and decided not to send a pull request right before hanging
out the "gone fishing" sign.  Whether that was a wise decision, I'm no
longer so sure.

If such a situation reappears in the future, would you rather have the
fixes and mindlessly revert them in case of any trouble or wait until
the respective maintainer reappers?

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan


The following changes since commit 79dba2eaa771c3173957eccfd288e0e0d12e4d3f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git master

Dan Carpenter (2):
      logfs: testing the wrong variable
      logfs: handle errors from get_mtd_device()

Joern Engel (10):
      LogFS: Fix typo in b6349ac8
      logfs: Return -EINVAL if filesystem image doesn't match
      logfs: fix logfs_seek_hole()
      logfs: Close i_ino reuse race
      logfs: survive logfs_buf_recover read errors
      logfs: commit reservations under space pressure
      logfs: fix compile failure
      logfs: fix sync
      logfs: remove unused variable
      logfs: handle powerfail on NAND flash

Prasad Joshi (1):
      logfs: initialize li->li_refcount

 fs/logfs/dev_bdev.c  |    6 ++++++
 fs/logfs/dev_mtd.c   |   26 +++++++++++++++++++++++++-
 fs/logfs/file.c      |   16 ++++++++++++----
 fs/logfs/gc.c        |   49 +++++++++++++++++++++----------------------------
 fs/logfs/inode.c     |    6 +++---
 fs/logfs/journal.c   |    7 +++----
 fs/logfs/logfs.h     |   13 ++++++++-----
 fs/logfs/readwrite.c |   19 +++++++++++++++----
 fs/logfs/segment.c   |    7 +++++--
 fs/logfs/super.c     |    8 ++++++--
 10 files changed, 104 insertions(+), 53 deletions(-)
