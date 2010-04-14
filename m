Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0DNS1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:27:36 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36971 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0DNS1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:27:34 -0400
Date: Wed, 14 Apr 2010 11:29:30 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] ceph fixes for 2.6.34-rc5
Message-ID: <Pine.LNX.4.64.1004141121320.10273@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following ceph bug fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a few one-liners (leaked dentry refs, rehashing hashed dentries, 
off-by-one error), a few patches fixing up writeback for snapshotted data 
and metadata, and one patch to decode an updated version of the osd map 
that should get into .35 to make everyone's life easier.

Thanks-
sage

--

Sage Weil (8):
      ceph: fix dentry rehashing on virtual .snap dir
      ceph: allow writeback of snapped pages older than 'oldest' snapc
      ceph: fix snap context reference leaks
      ceph: fix leaked inode ref due to snap metadata writeback race
      ceph: fix ack counter reset on connection reset
      ceph: decode v5 of osdmap (pool names) [protocol change]
      ceph: fix dentry reference leak in dcache readdir
      ceph: queue_cap_snap should always queue dirty context

Yehuda Sadeh (1):
      ceph: reserve one more caps space when doing readdir

 fs/ceph/addr.c      |   62 +++++++++---------
 fs/ceph/caps.c      |   42 +++++++++---
 fs/ceph/dir.c       |    7 +-
 fs/ceph/inode.c     |   10 +++-
 fs/ceph/messenger.c |    1 +
 fs/ceph/osdmap.c    |  180 +++++++++++++++++++++++++++++++--------------------
 fs/ceph/osdmap.h    |    1 +
 fs/ceph/rados.h     |    6 +-
 fs/ceph/snap.c      |   26 ++++----
 fs/ceph/super.h     |    3 +-
 10 files changed, 204 insertions(+), 134 deletions(-)

