Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2JFSsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:48:45 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33576 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2JFSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:48:41 -0400
Date: Sat, 6 Oct 2012 11:48:40 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for -rc1
Message-ID: <alpine.DEB.2.00.1210061139230.18880@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The bulk of this pull is a series from Alex that refactors and cleans up 
the RBD code to lay the groundwork for supporting the new image format and 
evolving feature set.  There are also some cleanups in libceph, and for 
ceph there's fixed validation of file striping layouts and a bugfix in 
the code handling a shrinking MDS cluster.

Thanks!
sage

----------------------------------------------------------------
Alex Elder (62):
      rbd: simplify __rbd_init_snaps_header()
      rbd: make snap_names_len a u64
      rbd: ensure invalid pointers are made null
      rbd: use sizeof (object) instead of sizeof (type)
      rbd: rearrange rbd_header_from_disk()
      rbd: return earlier in rbd_header_from_disk()
      rbd: expand rbd_dev_ondisk_valid() checks
      rbd: separate reading header from decoding it
      ceph: let path portion of mount "device" be optional
      rbd: rename block_name -> object_prefix
      rbd: add new snapshots at the tail
      rbd: handle locking inside __rbd_client_find()
      rbd: don't over-allocate space for object prefix
      rbd: kill incore snap_names_len
      rbd: more cleanup in rbd_header_from_disk()
      rbd: move rbd_opts to struct rbd_device
      rbd: add read_only rbd map option
      rbd: kill notify_timeout option
      rbd: bio_chain_clone() cleanups
      rbd: drop needless test in rbd_rq_fn()
      rbd: check for overflow in rbd_get_num_segments()
      rbd: split up rbd_get_segment()
      rbd: define rbd_assert()
      rbd: rename rbd_id_get()
      rbd: rename __rbd_init_snaps_header()
      rbd: kill rbd_dev->q
      rbd: kill rbd_image_header->total_snaps
      rbd: separate mapping info in rbd_dev
      rbd: record mapped size
      rbd: return snap name from rbd_add_parse_args()
      rbd: set mapping name with the rest
      rbd: simplify snap_by_name() interface
      rbd: do some header initialization earlier
      rbd: simplify rbd_init_disk() a bit
      rbd: move locking out of rbd_header_set_snap()
      rbd: don't register snapshots in bus_add_dev()
      rbd: use snaps list in rbd_snap_by_name()
      rbd: assign header name later
      rbd: defer registering snapshot devices
      rbd: call set_snap() before snap_devs_update()
      rbd: read the header before registering device
      rbd: defer setting device id
      rbd: call rbd_init_disk() sooner
      rbd: drop dev registration check for new snap
      rbd: set initial capacity in rbd_init_disk()
      rbd: set up watch before announcing disk
      rbd: pass flags to rbd_req_sync_exec()
      rbd: support data returned from OSD methods
      rbd: define some new format constants
      rbd: define rbd_dev_image_id()
      rbd: kill create_snap sysfs entry
      rbd: don't use index in __rbd_add_snap_dev()
      rbd: add an rbd features field
      rbd: encapsulate code that gets snapshot info
      rbd: lay out header probe infrastructure
      rbd: add code to get the size of a v2 rbd image
      rbd: get the object prefix for a v2 rbd image
      rbd: get image features for a v2 image
      rbd: get the snapshot context for a v2 image
      rbd: get snapshot name for a v2 image
      rbd: update remaining header fields for v2
      ceph: avoid 32-bit page index overflow

Iulius Curt (1):
      libceph: Fix sparse warning

Sage Weil (5):
      libceph: remove unused monc->have_fsid
      libceph: check for invalid mapping
      ceph: propagate layout error on osd request creation
      rbd: BUG on invalid layout
      ceph: return EIO on invalid layout on GET_DATALOC ioctl

Wei Yongjun (2):
      ceph: use list_move_tail instead of list_del/list_add_tail
      ceph: convert to use le32_add_cpu()

Yan, Zheng (1):
      ceph: Fix oops when handling mdsmap that decreases max_mds

 Documentation/ABI/testing/sysfs-bus-rbd |   18 +-
 drivers/block/rbd.c                     | 1790 ++++++++++++++++++++-----------
 drivers/block/rbd_types.h               |   27 +-
 fs/ceph/addr.c                          |   19 +-
 fs/ceph/caps.c                          |    2 +-
 fs/ceph/file.c                          |    4 +-
 fs/ceph/ioctl.c                         |    8 +-
 fs/ceph/mds_client.c                    |    3 +-
 fs/ceph/super.c                         |   37 +-
 include/linux/ceph/mon_client.h         |    1 -
 include/linux/ceph/osd_client.h         |    2 +-
 include/linux/ceph/osdmap.h             |    6 +-
 net/ceph/mon_client.c                   |    7 +-
 net/ceph/osd_client.c                   |   47 +-
 net/ceph/osdmap.c                       |   18 +-
 net/ceph/pagelist.c                     |    5 +-
 16 files changed, 1302 insertions(+), 692 deletions(-)
