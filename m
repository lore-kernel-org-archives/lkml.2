Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2C0TZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:25:25 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46174 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2C0TZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=y6TjdWQm5Dpgj4vLZibhS8MKBXpqS9O6wmLCp+CChWcd29Ux
	UOywueHdCTg2y+c3wio8LPidUk3cx4MFDyNW4+CK2hd7F8ooYKEy+bKUEHwW4gsX
	ao5CcF4nR3z0Upqkh5l6oEDaiC1or6J1GmRmywDtSznrIgO4ZaU/HA7Wbzo=
Date: Tue, 27 Mar 2012 12:25:22 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.4-rc1
Message-ID: <Pine.LNX.4.64.1203271218280.31157@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Alex has been busy.  There are a range of rbd and libceph cleanups, 
especially surrounding device setup and teardown, and a few critical fixes 
in that code.  There are more cleanups in the messenger code, virtual 
xattrs, a fix for CRC calculation/checks, and lots of other miscellaneous 
stuff.

There's a patch from Amon Ott to make inos behave a bit better on 32-bit 
boxes, some decode check fixes from Xi Wang, and network throttling fix 
from Jim Schutt, and a couple RBD fixes from Josh Durgin.

No new functionality, just a lot of cleanup and bug fixing.

Thanks!
sage



----------------------------------------------------------------
Alex Elder (58):
      ceph: don't reset s_cap_ttl to zero
      ceph: use a shared zero page rather than one per messenger
      ceph: make use of "else" where appropriate
      ceph: kill addr_str_lock spinlock; use atomic instead
      ceph: eliminate some needless casts
      ceph: eliminate some abusive casts
      ceph: don't null-terminate xattr values
      ceph: pass inode rather than table to ceph_match_vxattr()
      ceph: use a symbolic name for "ceph." extended attribute namespace
      ceph: use macros to normalize vxattr table definitions
      ceph: drop "_cb" from name of struct ceph_vxattr_cb
      ceph: encode type in vxattr callback routines
      ceph: avoid repeatedly computing the size of constant vxattr names
      ceph: make ceph_setxattr() and ceph_removexattr() more alike
      rbd: a few small cleanups
      rbd: make ceph_parse_options() return a pointer
      rbd: do not duplicate ceph_client pointer in rbd_device
      rbd: encapsulate new rbd id selection
      rbd: rework calculation of new rbd id's
      rbd: protect the rbd_dev_list with a spinlock
      rbd: tie rbd_dev_list changes to rbd_id operations
      rbd: restore previous rbd id sequence behavior
      rbd: release client list lock sooner
      rbd: move ctl_mutex lock inside rbd_get_client()
      rbd: move ctl_mutex lock inside rbd_client_create()
      rbd: rename "node_lock"
      rbd: a few simple changes
      rbd: have rbd_get_client() return a rbd_client
      rbd: reduce memory used for rbd_dev fields
      rbd: simplify error handling in rbd_add()
      rbd: encapsulate argument parsing for rbd_add()
      rbd: don't use sscanf() in rbd_add_parse_args()
      rbd: do a few checks at build time
      rbd: have rbd_parse_args() report found mon_addrs size
      rbd: don't allocate mon_addrs buffer in rbd_add()
      rbd: fix module sysfs setup/teardown code
      rbd: do some refactoring
      rbd: small changes
      rbd: don't drop the rbd_id too early
      libceph: move prepare_write_banner()
      libceph: encapsulate connection kvec operations
      libceph: make ceph_msgr_wq private
      libceph: encapsulate some messenger cleanup code
      libceph: make ceph_tcp_connect() return int
      libceph: a few small changes
      ceph: ensure Boolean options support both senses
      libceph: use "do" in CRC-related Boolean variables
      libceph: separate CRC calculation from byte swapping
      libceph: do crc calculations outside loop
      libceph: small refactor in write_partial_kvec()
      libceph: some simple changes
      libceph: fix inverted crc option logic
      libceph: use kernel_sendpage() for sending zeroes
      libceph: only call kernel_sendpage() via helper
      libceph: get rid of zero_page_address
      libceph: rename "page_shift" variable to something sensible
      libceph: isolate kmap() call in write_partial_msg_pages()
      ceph: fix three bugs, two in ceph_vxattrcb_file_layout()

Amon Ott (1):
      ceph: use 2 instead of 1 as fallback for 32-bit inode number

Jim Schutt (1):
      net/ceph: Only clear SOCK_NOSPACE when there is sufficient space in the socket buffer

Josh Durgin (2):
      rbd: use a single value of snap_name to mean no snap
      rbd: move snap_rwsem to the device, rename to header_rwsem

Xi Wang (3):
      ceph: avoid panic with mismatched symlink sizes in fill_inode()
      libceph: fix overflow check in crush_decode()
      ceph: fix overflow check in build_snap_context()

 drivers/block/rbd.c            |  730 ++++++++++++++++++++++++----------------
 drivers/block/rbd_types.h      |    4 -
 fs/ceph/inode.c                |   11 +-
 fs/ceph/mds_client.c           |    7 +-
 fs/ceph/snap.c                 |    2 +-
 fs/ceph/super.c                |   19 +-
 fs/ceph/super.h                |    4 +-
 fs/ceph/xattr.c                |  202 ++++++++----
 include/linux/ceph/libceph.h   |    2 +-
 include/linux/ceph/messenger.h |    5 +-
 net/ceph/ceph_common.c         |   26 +-
 net/ceph/messenger.c           |  456 +++++++++++++------------
 net/ceph/osdmap.c              |    3 +-
 13 files changed, 868 insertions(+), 603 deletions(-)
