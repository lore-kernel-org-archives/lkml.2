Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2JMAUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 20:20:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37141 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2JMAUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 20:20:05 -0400
Date: Sat, 13 Oct 2012 01:20:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 3
Message-ID: <20121013002003.GL2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Stuff from Jeff Layton, mostly.  Sanitizing interplay between
audit and namei, removing a lot of insanity from audit_inode() mess
and getting things ready for his ESTALE patchset.  Please, pull from
the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Eric Paris (1):
      audit: make audit_compare_dname_path use parent_len helper

Jeff Layton (19):
      audit: remove unnecessary NULL ptr checks from do_path_lookup
      audit: pass in dentry to audit_copy_inode wherever possible
      audit: no need to walk list in audit_inode if name is NULL
      audit: reverse arguments to audit_inode_child
      audit: add a new "type" field to audit_names struct
      audit: set the name_len in audit_inode for parent lookups
      audit: remove dirlen argument to audit_compare_dname_path
      audit: optimize audit_compare_dname_path
      audit: overhaul __audit_inode_child to accomodate retrying
      vfs: allocate page instead of names_cache buffer in mount_block_root
      acct: constify the name arg to acct_on
      vfs: unexport getname and putname symbols
      vfs: define struct filename and have getname() return it
      audit: allow audit code to satisfy getname requests from its names_list
      vfs: turn do_path_lookup into wrapper around struct filename variant
      vfs: make path_openat take a struct filename pointer
      audit: make audit_inode take struct filename
      vfs: embed struct filename inside of names_cache allocation if possible
      procfs: don't need a PATH_MAX allocation to hold a string representation of an int

Diffstat:
 arch/alpha/kernel/osf_sys.c             |   16 +-
 arch/arm64/kernel/sys.c                 |    4 +-
 arch/arm64/kernel/sys_compat.c          |    6 +-
 arch/avr32/kernel/process.c             |    4 +-
 arch/blackfin/kernel/process.c          |    4 +-
 arch/cris/arch-v10/kernel/process.c     |    4 +-
 arch/cris/arch-v32/kernel/process.c     |    4 +-
 arch/h8300/kernel/process.c             |    4 +-
 arch/hexagon/kernel/syscall.c           |    4 +-
 arch/ia64/kernel/process.c              |    4 +-
 arch/m32r/kernel/process.c              |    4 +-
 arch/microblaze/kernel/sys_microblaze.c |    4 +-
 arch/mips/kernel/linux32.c              |    4 +-
 arch/mips/kernel/syscall.c              |    4 +-
 arch/openrisc/kernel/process.c          |    4 +-
 arch/parisc/hpux/fs.c                   |    4 +-
 arch/parisc/kernel/process.c            |    4 +-
 arch/parisc/kernel/sys_parisc32.c       |    4 +-
 arch/score/kernel/sys_score.c           |    4 +-
 arch/sh/kernel/process_32.c             |    4 +-
 arch/sh/kernel/process_64.c             |    4 +-
 arch/sparc/kernel/process_32.c          |    4 +-
 arch/sparc/kernel/process_64.c          |    4 +-
 arch/sparc/kernel/sys_sparc32.c         |    4 +-
 arch/tile/kernel/process.c              |    8 +-
 arch/unicore32/kernel/sys.c             |    4 +-
 arch/xtensa/kernel/process.c            |    4 +-
 fs/btrfs/ioctl.c                        |    2 +-
 fs/compat.c                             |   12 +-
 fs/exec.c                               |   14 +-
 fs/filesystems.c                        |    4 +-
 fs/internal.h                           |    4 +-
 fs/namei.c                              |  213 ++++++++++++++++++++----------
 fs/namespace.c                          |    4 +-
 fs/open.c                               |   29 ++++-
 fs/proc/base.c                          |    5 +-
 fs/quota/quota.c                        |    4 +-
 fs/xattr.c                              |    8 +-
 include/linux/audit.h                   |   69 +++++++---
 include/linux/fs.h                      |   21 +++-
 include/linux/fsnotify.h                |    8 +-
 init/do_mounts.c                        |    7 +-
 ipc/mqueue.c                            |   17 ++-
 kernel/acct.c                           |    6 +-
 kernel/audit.h                          |    7 +-
 kernel/audit_watch.c                    |    3 +-
 kernel/auditfilter.c                    |   65 ++++++----
 kernel/auditsc.c                        |  217 +++++++++++++++++++++----------
 mm/swapfile.c                           |   11 +-
 49 files changed, 544 insertions(+), 312 deletions(-)
