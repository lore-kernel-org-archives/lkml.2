Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1EYRsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:48:19 -0400
Received: from cobra.newdream.net ([66.33.216.30]:58379 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1EYRsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=H6+5SxS7FPXTsmqpdVWfIU2OnuYS+CX5gscJ/ZyQcJ6AZAtT
	uTjab2oR7SlQwi2TzmAEKlK7mOmTXE5B81KHUCY8osa2yrWdvQFw3Df/nHaeqh8a
	ixzqffuCrIxW4pX1gbSC+VnLpnOy7YTL6fWD30JU3CzkpgcJHxCGRqi7gAc=
Date: Wed, 25 May 2011 10:49:39 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for -rc1
Message-ID: <Pine.LNX.4.64.1105251031510.9500@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates for 3.0.0-rc1 (or whatever it ends 
up being) from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Most of this is a pile of small, rare bugs that the coverity run 
turned up.  There are also several bug fixes that came up in the real 
world, including a messenger race, looping with concurrent syncs, and a 
dangling pointer under directory rename thrashing (fsstress).  RBD now 
notices when the image size changes out from underneath it, and there are 
a few improvements in the NFS reexport code to make it more robust.

Thanks!
sage


Sage Weil (23):
      ceph: take reference on mds request r_unsafe_dir
      libceph: handle connection reopen race with callbacks
      libceph: remove unused variable
      libceph: fix uninitialized value when no get_authorizer method is set
      ceph: use snprintf for dirstat content
      libceph: use snprintf for formatting object name
      libceph: use snprintf for unknown addrs
      ceph: fix rare potential cap leak
      libceph: fix osdmap timestamp assignment
      ceph: fix broken comparison in readdir loop
      libceph: fix TAG_WAIT case
      libceph: add missing breaks in addr_set_port
      ceph: remove useless check
      ceph: check return value for start_request in writepages
      rbd: warn on update_snaps failure on notify
      rbd: cleanup: make kfree match kmalloc
      rbd: use snprintf for disk->disk_name
      ceph: use LOOKUPINO to make unconnected nfs fh more reliable
      ceph: avoid inode lookup on nfs fh reconnect
      rbd: handle online resize of underlying rbd image
      libceph: handle new osdmap down/state change encoding
      libceph: subscribe to osdmap when cluster is full
      ceph: fix cap flush race reentrancy

 drivers/block/rbd.c          |   27 +++++++++-----
 fs/ceph/addr.c               |    5 +--
 fs/ceph/caps.c               |   61 ++++++++++++++++---------------
 fs/ceph/dir.c                |    7 ++--
 fs/ceph/export.c             |   25 +++++++++++--
 fs/ceph/mds_client.c         |    7 +++-
 fs/ceph/mds_client.h         |    1 +
 include/linux/ceph/ceph_fs.h |    1 +
 net/ceph/messenger.c         |   82 ++++++++++++++++++++++++++++++++----------
 net/ceph/osd_client.c        |   19 +++++++++-
 net/ceph/osdmap.c            |   13 +++++--
 11 files changed, 173 insertions(+), 75 deletions(-)
