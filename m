Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0DMXx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:53:27 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:59403 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0DMXwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id; q=dns; s=drama; b=gG8ITKtxoi6+ueudl
	DnHc4qSecGeeVYHb9kTNG7uSAEga+DWTM7KewpUWnasnVcimB8gy5x6MXnDJ45zv
	n9+BctLzz5w0WttfZVjPkA8xcTmjmV/Kb472Bn1r7dVUHpkehVhz5ioCQNb4Er7e
	Ib9NX+2697v52jR5B+32pm+YVg=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, yehudasa@gmail.com, sage@newdream.net,
       axboe@kernel.dk, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 0/6] Ceph RADOS block device
Date: Tue, 13 Apr 2010 16:29:09 -0700
Message-Id: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a linux rados block device. It allows striping of data across rados, the ceph distributed block layer, and is binary compatible with Christian Brunner's kvm-rbd implementation. Similarly to the Sheepdog project, it stripes the block device across 4MB (or other configurable size) objects stored by the distributed object store, and enjoys all the rados features (high availability, scalability, etc.). Future versions will be able to use the rados snapshots mechanism.

A use case for this device would be to have some kind of a local file system created on it, and use it with conjuction of kvm to do migration and other related stuff. Another option would be to use it as data devices for other distributed file systems (e.g., ocfs2, gfs2).

The actual device driver is implemented in the last patch of the series, and is based on osdblk. Currently, it resides under the fs/ceph tree and does not exist as a separate module of its own, such that the ceph.ko module contains both the ceph file system and the rbd block device. Another option would be to have it as a separate module that resides under drivers/block, however, it would still depend on the ceph.ko module.

Any comments, questions, suggestions are more than welcome,

Yehuda

---
 fs/ceph/Makefile     |    3 +-
 fs/ceph/caps.c       |    2 +-
 fs/ceph/debugfs.c    |   11 +-
 fs/ceph/file.c       |   56 +++-
 fs/ceph/mds_client.c |   11 +-
 fs/ceph/messenger.c  |  185 +++++++--
 fs/ceph/messenger.h  |    5 +-
 fs/ceph/mon_client.c |   18 +-
 fs/ceph/msgpool.c    |    4 +-
 fs/ceph/osd_client.c |  193 ++++++---
 fs/ceph/osd_client.h |   27 ++
 fs/ceph/rbd.c        | 1224 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/rbd.h        |    8 +
 fs/ceph/super.c      |  165 ++++++--
 fs/ceph/super.h      |   31 ++-
 15 files changed, 1786 insertions(+), 157 deletions(-)
