Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1FMSLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:11:15 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34396 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1FMSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=qF+5zVUsz02M6RddQDgBDnbskjBgSKXAxTAM6DouyLTSr6dg
	g776g4z1koLXq9m2fTvuMRZTPeXgZnbSTRoyvmySFEiHF/1RGizMK5AOAl5NH3it
	N+oszubdycNBjibK6HTKjjBsD/h5ZJwOaeAtaZBZhBm+NEIdyz95UBXIEbw=
Date: Mon, 13 Jun 2011 11:13:21 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.0-rc3
Message-ID: <Pine.LNX.4.64.1106131108150.16514@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are some igrab/ihold fixes, a sync hang when multiple syncs are in 
progress, a couple fixes for O_DIRECT/sync io reads and holes, and a fix 
for unwinding flock when a request is aborted (blocking process is 
killed).

There are a few other things that we are still testing with sync io and 
O_DIRECT that should be ready in the next week or two.

Thanks!
sage


Sage Weil (5):
      ceph: use ihold when we already have an inode ref
      ceph: fix sync vs canceled write
      ceph: fix short sync reads from the OSD
      ceph: fix ENOENT logic in striped_read
      ceph: unwind canceled flock state

 fs/ceph/addr.c        |    2 +-
 fs/ceph/caps.c        |   10 ++++------
 fs/ceph/dir.c         |   11 +++++++----
 fs/ceph/export.c      |    4 ++--
 fs/ceph/file.c        |   35 +++++++++++++++++++----------------
 fs/ceph/inode.c       |   18 ++++++++++--------
 fs/ceph/ioctl.c       |    6 ++++--
 fs/ceph/locks.c       |   29 ++++++++++++++++++-----------
 fs/ceph/snap.c        |    2 +-
 fs/ceph/xattr.c       |    6 ++++--
 net/ceph/osd_client.c |   15 ++++++++++-----
 11 files changed, 80 insertions(+), 58 deletions(-)
