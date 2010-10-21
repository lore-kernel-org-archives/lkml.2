Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0JUPVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:21:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57443 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0JUPVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:21:18 -0400
MIME-Version: 1.0
Message-ID: <e0836cf5-8328-48b9-bea7-872b357b7e82@default>
Date: Thu, 21 Oct 2010 08:20:47 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] mm/vfs/fs:cleancache for 2.6.37 merge window
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus --

Please pull:

 git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git for-linus

since git commit cb655d0f3d57c23db51b981648e452988c0223f9:
Linus Torvalds (1):

    Linux 2.6.36-rc7

This cleancache patchset crosses multiple subsystem boundaries and
at the recent filesystem/storage/mm summit, people suggested that
I should just submit it to linux-next (done), and directly to you
at the next merge window.  Previous lkml postings received a great
deal of review and comment from a wide variety of maintainers, as
documented in the commit logs.

In addition, the cleancache shim to Xen Transcendent Memory makes
use of and is dependent on the cleancache patchset.  Jeremy Fitzhardinge
asked that I just include the shim in my tree to be pulled at the
same time, to avoid any merge ordering issues.  (Another cleancache
user, zcache, developed by Nitin Gupta has been submitted for the
drivers/staging tree and will follow at some point, though possibly
not until the next merge window.)

The patches apply cleanly against linux-2.6.36-rc7.  In
linux-next, sfr had to manually resolve a couple of very minor merge
conflicts in mm/Kconfig and include/linux/fs.h due to minor changes
in other trees.

If you have any questions or concerns, please let me know!

Thanks,
Dan

P.S. This is my first direct submission to you and today
happens to be my 50th birthday, so please be kind :-)

Dan Magenheimer (9):
      mm/fs: cleancache documentation
      fs: add field to superblock to support cleancache
      mm: cleancache core ops functions and config
      mm/fs: add hooks to support cleancache
      ext3: add cleancache support
      btrfs: add cleancache support
      ext4: add cleancache support
      ocfs2: add cleancache support
      xen: cleancache shim to Xen Transcendent Memory

 .../ABI/testing/sysfs-kernel-mm-cleancache         |   11 +
 Documentation/vm/cleancache.txt                    |  267 ++++++++++++++++++++
 arch/x86/include/asm/xen/hypercall.h               |    7 +
 drivers/xen/Makefile                               |    1 +
 drivers/xen/tmem.c                                 |  264 +++++++++++++++++++
 fs/btrfs/extent_io.c                               |    9 +
 fs/btrfs/super.c                                   |    2 +
 fs/buffer.c                                        |    5 +
 fs/ext3/super.c                                    |    2 +
 fs/ext4/super.c                                    |    2 +
 fs/mpage.c                                         |    7 +
 fs/ocfs2/super.c                                   |    2 +
 fs/super.c                                         |    3 +
 include/linux/cleancache.h                         |  118 +++++++++
 include/linux/fs.h                                 |    5 +
 include/xen/interface/xen.h                        |   22 ++
 mm/Kconfig                                         |   22 ++
 mm/Makefile                                        |    1 +
 mm/cleancache.c                                    |  245 ++++++++++++++++++
 mm/filemap.c                                       |   11 +
 mm/truncate.c                                      |   10 +
 21 files changed, 1016 insertions(+), 0 deletions(-)
