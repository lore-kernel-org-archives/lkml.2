Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2E3QB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:01:29 -0400
Received: from cobra.newdream.net ([66.33.216.30]:35660 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2E3QB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=zZHWKRYq1Cx9xIznzfTS0fMNgR3i9ZKRBh7D09NmgcWN/hMG
	bxk1AtYKNpzq3h6C4ZT75P3JTLszeTzqSCBDFppL/TaTS4yDD2IXs9noqSUmz8vX
	KavTmb2rk4wDuUC9KtQI/itO9fEccevIEbHZn7gMGIvvDo3BmY9W0d3eo6E=
Date: Wed, 30 May 2012 09:01:24 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.5
Message-ID: <Pine.LNX.4.64.1205300852320.8052@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates for rc1 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git master

There are some updates and cleanups to the CRUSH placement code, a bug fix 
with incremental maps, several cleanups and fixes from Josh Durgin in the 
RBD block device code, a series of cleanups and bug fixes from Alex Elder 
in the messenger code, and some miscellaneous bounds checking and gfp 
cleanups/fixes.

There are a couple of simple merge conflict resolutions that Stephen is 
carrying in linux-next in net/ceph/messenger.c and net/ceph/osdmap.c.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (21):
      rbd: don't hold spinlock during messenger flush
      ceph: osd_client: fix endianness bug in osd_req_encode_op()
      ceph: messenger: use read_partial() in read_partial_message()
      ceph: messenger: update "to" in read_partial() caller
      ceph: messenger: change read_partial() to take "end" arg
      libceph: don't reset kvec in prepare_write_banner()
      ceph: messenger: reset connection kvec caller
      ceph: messenger: send banner in process_connect()
      ceph: drop msgr argument from prepare_write_connect()
      ceph: don't set WRITE_PENDING too early
      ceph: messenger: check prepare_write_connect() result
      ceph: messenger: rework prepare_connect_authorizer()
      ceph: messenger: check return from get_authorizer
      ceph: define ceph_auth_handshake type
      ceph: messenger: reduce args to create_authorizer
      ceph: ensure auth ops are defined before use
      ceph: have get_authorizer methods return pointers
      ceph: use info returned by get_authorizer
      ceph: return pointer from prepare_connect_authorizer()
      ceph: rename prepare_connect_authorizer()
      ceph: add auth buf in prepare_write_connect()

Dan Carpenter (1):
      rbd: use gfp_flags parameter in rbd_header_from_disk()

Josh Durgin (6):
      rbd: protect read of snapshot sequence number
      rbd: store snapshot id instead of index
      rbd: remove conditional snapid parameters
      rbd: fix snapshot size type
      rbd: rename __rbd_update_snaps to __rbd_refresh_header
      rbd: correct sysfs snap attribute documentation

Sage Weil (15):
      ceph: drop support for preferred_osd pgs
      ceph: refactor SETLAYOUT and SETDIRLAYOUT ioctl checks into common helper
      crush: clean up types, const-ness
      crush: adjust local retry threshold
      crush: be more tolerant of nonsensical crush maps
      crush: use a temporary variable to simplify crush_do_rule
      crush: remove forcefeed functionality
      crush: remove parent maps
      crush: fix tree node weight lookup
      crush: fix memory leak when destroying tree buckets
      crush: warn on do_rule failure
      ceph: fully initialize new layout
      ceph: ignore preferred_osd field
      libceph: avoid unregistering osd request when not registered
      libceph: fix pg_temp updates

Xi Wang (2):
      ceph: fix bounds check in ceph_decode_need and ceph_encode_need
      rbd: fix integer overflow in rbd_header_from_disk()

 Documentation/ABI/testing/sysfs-bus-rbd |    4 +-
 drivers/block/rbd.c                     |   72 +++++-------
 fs/ceph/file.c                          |    1 -
 fs/ceph/ioctl.c                         |  102 ++++++++---------
 fs/ceph/ioctl.h                         |    2 +
 fs/ceph/mds_client.c                    |   54 ++++-----
 fs/ceph/mds_client.h                    |    5 +-
 fs/ceph/xattr.c                         |    9 --
 include/linux/ceph/auth.h               |   12 ++-
 include/linux/ceph/ceph_fs.h            |    4 +-
 include/linux/ceph/decode.h             |    9 +-
 include/linux/ceph/messenger.h          |    6 +-
 include/linux/ceph/osd_client.h         |   11 +-
 include/linux/ceph/osdmap.h             |    2 -
 include/linux/crush/crush.h             |   18 +--
 include/linux/crush/mapper.h            |    7 +-
 net/ceph/auth_none.c                    |   15 +--
 net/ceph/auth_x.c                       |   15 +--
 net/ceph/crush/crush.c                  |   39 +------
 net/ceph/crush/mapper.c                 |  124 ++++++++-------------
 net/ceph/messenger.c                    |  182 ++++++++++++++++++-------------
 net/ceph/osd_client.c                   |   63 ++++++-----
 net/ceph/osdmap.c                       |   73 ++++--------
 23 files changed, 376 insertions(+), 453 deletions(-)
