Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab2JZOTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:19:37 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:52662 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217Ab2JZOTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:19:36 -0400
X-ASG-Debug-ID: 1351261174-0421b562ecaac50001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 26 Oct 2012 10:19:32 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20121026141932.GD23729@shiny>
X-ASG-Orig-Subj: [GIT PULL] Btrfs fixes
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1351261174
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.112446
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has our series of fixes for the next rc.  The biggest batch is from Jan
Schmidt, fixing up some problems in our subvolume quota code and fixing
btrfs send/receive to work with the new extended inode refs.

My git tree is against 3.6, but these were all retested against your
current git.

Jan Schmidt (7) commits (+149/-76):
    Btrfs: don't put removals from push_node_left into tree mod log twice (+7/-2)
    Btrfs: fix a tree mod logging issue for root replacement operations (+2/-8)
    Btrfs: tree mod log's old roots could still be part of the tree (+21/-4)
    Btrfs: fix extent buffer reference for tree mod log roots (+1/-1)
    Btrfs: extended inode refs support for send mechanism (+94/-58)
    Btrfs: comment for loop in tree_mod_log_insert_move (+5/-0)
    Btrfs: determine level of old roots (+19/-3)

Josef Bacik (2) commits (+8/-6):
    Btrfs: Use btrfs_update_inode_fallback when creating a snapshot (+6/-5)
    Btrfs: do not bug when we fail to commit the transaction (+2/-1)

Stefan Behrens (1) commits (+2/-2):
    Btrfs: Fix wrong error handling code

Lukas Czerner (1) commits (+2/-1):
    btrfs: Return EINVAL when length to trim is less than FSB

Arne Jansen (1) commits (+2/-1):
    Btrfs: send correct rdev and mode in btrfs-send

Gabriel de Perthuis (1) commits (+1/-1):
    Fix a sign bug causing invalid memory access in the ino_paths ioctl.

Liu Bo (1) commits (+5/-3):
    Btrfs: fix memory leak when cloning root's node

Alex Lyakas (1) commits (+13/-14):
    Btrfs: Send: preserve ownership (uid and gid) also for symlinks.

Miao Xie (1) commits (+7/-0):
    Btrfs: fix deadlock caused by the nested chunk allocation

Tsutomu Itoh (1) commits (+13/-4):
    Btrfs: fix memory leak in btrfs_quota_enable()

Total: (17) commits (+202/-108)
 fs/btrfs/backref.c     |  28 ++++-----
 fs/btrfs/backref.h     |   4 ++
 fs/btrfs/ctree.c       |  70 +++++++++++++++++-----
 fs/btrfs/ctree.h       |   3 +
 fs/btrfs/extent_io.c   |   4 +-
 fs/btrfs/inode.c       |   7 +--
 fs/btrfs/ioctl.c       |   6 +-
 fs/btrfs/qgroup.c      |  17 ++++--
 fs/btrfs/send.c        | 156 ++++++++++++++++++++++++++++++-------------------
 fs/btrfs/transaction.c |   2 +-
 fs/btrfs/volumes.c     |   7 +++
 11 files changed, 199 insertions(+), 105 deletions(-)
