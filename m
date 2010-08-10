Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab0HJWkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:40:32 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49949 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab0HJWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:40:29 -0400
Date: Tue, 10 Aug 2010 15:40:36 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 2.6.36-rc1
Message-ID: <Pine.LNX.4.64.1008101524290.9790@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates for 2.6.36-rc1:

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a handful of bug fixes, a few of which are critical, some others 
improving behavior when using a clustered MDSs.  Some mount options are 
also fixed, and sync_fs works a bit better (pay attention to wait flag).  
The rest is fleshing out the feature set (flock/fcntl lock support, 
consistency relaxation, related protocol extensions) and then lots of code 
cleanup.

Thanks!
sage


Greg Farnum (5):
      ceph: add ceph_get_cap_for_mds function.
      ceph: handle ESTALE properly; on receipt send to authority if it wasn't
      ceph: add CEPH_FEATURE_FLOCK to the supported feature bits
      ceph: define on-wire types, constants for file locking support
      ceph: add flock/fcntl lock support

Sage Weil (31):
      ceph: request FILE_LAZYIO cap when LAZY file mode is set
      ceph: add LAZYIO ioctl to mark a file description for lazy consistency
      ceph: perform lazy writes when file mode and caps permit
      ceph: perform lazy reads when file mode and caps permit
      ceph: drop unused argument
      ceph: simplify add_cap_releases
      ceph: simplify caps revocation, fix for multimds
      ceph: skip if no auth cap in flush_snaps
      ceph: track laggy state of mds from mdsmap
      ceph: only set num_pages in calc_layout
      ceph: introduce helper to connect to mds export targets
      ceph: connect to export targets if mds is laggy
      ceph: connect to export targets on cap export
      ceph: remove unused 'monport' mount option
      ceph: clean up fsid mount option
      ceph: specify supported features in super.h
      ceph: strip misleading/obsolete version, feature info
      ceph: clean up header guards
      ceph: sync header defs with server code
      ceph: use %pU to print uuid (fsid)
      ceph: print useful error message when crush rule not found
      ceph: warn on missing snap realm
      ceph: make ->sync_fs not wait if wait==0
      ceph: fix decoding of pool snap info
      ceph: move AES iv definition to shared header
      ceph: support v2 client_caps encoding
      ceph: support v2 reconnect encoding
      ceph: whitespace cleanup
      ceph: constify dentry_operations
      ceph: do not ignore osd_idle_ttl mount option
      ceph: only queue async writeback on cap revocation if there is dirty data

Yehuda Sadeh (3):
      ceph: code cleanup
      ceph: do caps accounting per mds_client
      ceph: generalize mon requests, add pool op support

 fs/ceph/Makefile       |    2 +-
 fs/ceph/addr.c         |   16 ++-
 fs/ceph/armor.c        |    6 +-
 fs/ceph/auth.c         |    6 +-
 fs/ceph/auth_x.c       |    6 +-
 fs/ceph/buffer.c       |   16 ---
 fs/ceph/caps.c         |  303 +++++++++++++++++++++++++++---------------------
 fs/ceph/ceph_frag.h    |    4 +-
 fs/ceph/ceph_fs.c      |   50 ++++----
 fs/ceph/ceph_fs.h      |   87 +++++++++-----
 fs/ceph/ceph_hash.h    |    4 +-
 fs/ceph/ceph_strings.c |    3 +
 fs/ceph/crush/crush.h  |    4 +-
 fs/ceph/crush/hash.h   |    4 +-
 fs/ceph/crush/mapper.h |    4 +-
 fs/ceph/crypto.c       |   27 +++--
 fs/ceph/crypto.h       |    4 +-
 fs/ceph/debugfs.c      |   21 ++--
 fs/ceph/decode.h       |    6 +-
 fs/ceph/dir.c          |   10 +-
 fs/ceph/file.c         |   32 ++++--
 fs/ceph/inode.c        |    5 +-
 fs/ceph/ioctl.c        |   24 ++++
 fs/ceph/ioctl.h        |    2 +
 fs/ceph/locks.c        |  256 ++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c   |  235 ++++++++++++++++++++++++++++++--------
 fs/ceph/mds_client.h   |   30 +++++-
 fs/ceph/mdsmap.c       |    6 +-
 fs/ceph/mdsmap.h       |    8 ++
 fs/ceph/messenger.c    |   23 ++--
 fs/ceph/mon_client.c   |  170 ++++++++++++++++++++++++---
 fs/ceph/mon_client.h   |    5 +
 fs/ceph/msgr.h         |    4 +-
 fs/ceph/osd_client.c   |    9 +-
 fs/ceph/osdmap.c       |   37 +++++-
 fs/ceph/rados.h        |   13 ++-
 fs/ceph/super.c        |   88 ++++++++++-----
 fs/ceph/super.h        |   40 ++++---
 fs/ceph/xattr.c        |    2 +
 39 files changed, 1162 insertions(+), 410 deletions(-)
 create mode 100644 fs/ceph/locks.c
