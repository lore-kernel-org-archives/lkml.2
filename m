Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0G1RN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:13:29 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55199 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0G1RNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:13:25 -0400
Date: Wed, 28 Jul 2010 10:15:55 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] ceph fixes for 2.6.35
Message-ID: <Pine.LNX.4.64.1007281006010.4611@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this final set of ceph bug fixes for 2.6.35 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a trivial Kconfig fix, a wake_up patch that fixes hanging 
concurrent 'sync' instances (among other things), a couple memory leaks, 
and some dentry lease fixes that correct dentry release and caching 
behavior in the snapshotted portions of the namespace.

The rate of bug fixes continues to be unrelated to the upstream release 
cycle.  I'm hoping things will settle down a bit for 2.6.36!

Thanks!
sage


Robert P. J. Day (1):
      ceph: Correct obvious typo of Kconfig variable "CRYPTO_AES"

Sage Weil (5):
      ceph: avoid dcache readdir for snapdir
      ceph: fix d_release dop for snapdir, snapped dentries
      ceph: fix pg_mapping leak on pg_temp updates
      ceph: fix leak of dentry in ceph_init_dentry() error path
      ceph: fix dentry lease release

Yehuda Sadeh (1):
      ceph: use complete_all and wake_up_all

 fs/ceph/Kconfig      |    2 +-
 fs/ceph/caps.c       |   15 ++++++++-------
 fs/ceph/dir.c        |   13 ++++++++++---
 fs/ceph/file.c       |    2 +-
 fs/ceph/inode.c      |    6 ++++--
 fs/ceph/mds_client.c |   10 +++++-----
 fs/ceph/mon_client.c |    6 +++---
 fs/ceph/osd_client.c |    6 +++---
 fs/ceph/osdmap.c     |   26 +++++++++++++++-----------
 9 files changed, 50 insertions(+), 36 deletions(-)
