Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0KSWb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:31:28 -0500
Received: from cobra.newdream.net ([66.33.216.30]:47119 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab0KSWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:31:23 -0500
Date: Fri, 19 Nov 2010 14:35:32 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 2.6.37-rc3
Message-ID: <Pine.LNX.4.64.1011191429530.1019@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

It's an unfortunately rather big pile of bug fixes.  There's a revert to 
fix a regression from 2.6.36, a problem with network reconnects, a 
potential null deref, a series of small fixes that came up with clustered 
MDS testing, a fix for non-page aligned direct IO, and a readdir fix that 
turns up on 32bit arches.

Thanks!
sage


Sage Weil (16):
      Revert "ceph: update issue_seq on cap grant"
      ceph: fix small seq message skipping
      ceph: fix bad pointer dereference in ceph_fill_trace
      ceph: fix open for write on clustered mds
      ceph: only let auth caps update max_size
      ceph: re-request max_size if cap auth changes
      ceph: fix rdcache_gen usage and invalidate
      ceph: fix uid/gid on resent mds requests
      ceph: fix version check on racing inode updates
      ceph: fix update of ctime from MDS
      ceph: fix comment, remove extraneous args
      ceph: make page alignment explicit in osd interface
      ceph: explicitly specify page alignment in network messages
      ceph: fix dangling pointer
      ceph: fix frag offset for non-leftmost frags
      ceph: fix readdir EOVERFLOW on 32-bit archs

 fs/ceph/addr.c                  |    6 ++--
 fs/ceph/caps.c                  |   17 +++++++-----
 fs/ceph/dir.c                   |   16 +++++++++---
 fs/ceph/file.c                  |   52 +++++++++++++++++++++++++-------------
 fs/ceph/inode.c                 |   49 +++++++++++++++++++++++-------------
 fs/ceph/mds_client.c            |    7 +++-
 fs/ceph/mds_client.h            |    2 +
 fs/ceph/super.h                 |    4 +--
 include/linux/ceph/libceph.h    |    3 +-
 include/linux/ceph/messenger.h  |    1 +
 include/linux/ceph/osd_client.h |    7 +++-
 net/ceph/messenger.c            |   13 ++++-----
 net/ceph/osd_client.c           |   25 ++++++++++++------
 net/ceph/pagevec.c              |    3 +-
 14 files changed, 129 insertions(+), 76 deletions(-)
