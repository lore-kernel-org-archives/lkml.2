Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1CVTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:18:47 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52223 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1CVTSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=Pa0Zc6BPJ36BOmobBRCXmyuk7gaFTsnZsq5yu/R7jZU3j1Zm
	8DlAd1ALtbh4zp7aG/DT7PlbydprrEnL1uKP3AH/gNih0esQD8HXu0pCLCb4hN3C
	+ivcak9NzpXB38mzad+syKNstEzdrgD51cP30yhc3dTxlmZRAnraN8ovli8=
Date: Tue, 22 Mar 2011 12:21:25 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 2.6.39-rc1
Message-ID: <Pine.LNX.4.64.1103211602260.15400@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph and RBD updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git master

The biggest item is support for the object watch/notify framework that 
allows an RBD block device to get/send notifications about snapshot 
creation.  There is also some code refactoring in the osd_client that 
cleans things up and improves failure handling.  A few bug fixes for 
synchronous IO came in from Henry, there's an ino32 mount option to expose 
32 bit inos to 32 bit userspace, and there's some miscellaneous code 
cleanup.

The other piece of pending work is the dentry caching stuff, but that 
needs an ack on the d_prune dentry_operation.

Thanks!
sage


Henry C Chang (2):
      ceph: remove request from unsafe list if it is canceled/timed out
      ceph: add request to the tail of unsafe write list

Sage Weil (6):
      ceph: preserve I_COMPLETE across rename
      libceph: fix osd request queuing on osdmap updates
      ceph: remove debugfs debug cruft
      ceph: move readahead default to fs/ceph from libceph
      ceph: rename dentry_release -> d_release, fix comment
      rbd: update email address in Documentation

Tommi Virtanen (1):
      libceph: Fix base64-decoding when input ends in newline.

Yehuda Sadeh (4):
      ceph: update common header files
      ceph: add ino32 mount option
      libceph: add lingering request and watch/notify event framework
      rbd: use watch/notify for changes in rbd header

 Documentation/ABI/testing/sysfs-bus-rbd |    2 +-
 drivers/block/rbd.c                     |  361 +++++++++++++++++--
 fs/ceph/debugfs.c                       |    6 -
 fs/ceph/dir.c                           |   24 +-
 fs/ceph/file.c                          |   10 +-
 fs/ceph/inode.c                         |   25 +-
 fs/ceph/super.c                         |    9 +-
 fs/ceph/super.h                         |   66 +++-
 include/linux/ceph/ceph_fs.h            |   19 +-
 include/linux/ceph/libceph.h            |    1 -
 include/linux/ceph/osd_client.h         |   57 +++-
 include/linux/ceph/rados.h              |   39 ++-
 net/ceph/armor.c                        |    4 +-
 net/ceph/ceph_common.c                  |    1 +
 net/ceph/osd_client.c                   |  624 ++++++++++++++++++++++++-------
 15 files changed, 1018 insertions(+), 230 deletions(-)
