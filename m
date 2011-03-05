Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1CESWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 13:22:54 -0500
Received: from cobra.newdream.net ([66.33.216.30]:46774 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1CESWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 13:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=z1a6VzbBY8qGbNmrlmjPlCGx+XMAjhhZJWQDoKu8zsFWjam1
	74nWv1MD+VJIg4U4gAMwOvNARTldKbVKAHf1PVDbvPpo1bquh59kdEy4vvY8HTxD
	t+3gcCt8hYILLE/9sIVP+Izcf+3kylgEcP0Hyw04A695yRttYAjD4p/d53A=
Date: Sat, 5 Mar 2011 10:24:51 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.38-rc8
Message-ID: <Pine.LNX.4.64.1103041650420.3063@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a couple of patches reverting the broken NULL d_parent 
workaround, a couple patches disabling the "complete" flag behavior that 
depended on it, and some bugfixes.  Those include socket error handling 
fixups due to a switch to WQ_NON_REENTRANT workqueue behavior, a fix for 
short returns from get_user_pages, and a trivial fix to prevent the magic 
.snap directory from appearing within snapshots.

I should have sent these sooner.  Proper testing this time around got off 
to a slow start due to the d_parent regression and confusion about Nick's 
availability.

Thanks!
sage


Sage Weil (9):
      Revert "ceph: keep reference to parent inode on ceph_dentry"
      ceph: do not set I_COMPLETE
      ceph: do not clear I_COMPLETE from d_release
      libceph: fix handling of short returns from get_user_pages
      libceph: retry after authorization failure
      libceph: fix msgr backoff
      libceph: fix msgr keepalive flag
      libceph: fix msgr standby handling
      ceph: no .snap inside of snapped namespace

 fs/ceph/dir.c                  |   28 ++--------------
 fs/ceph/inode.c                |    2 +-
 fs/ceph/super.h                |    1 -
 include/linux/ceph/messenger.h |    2 +-
 net/ceph/messenger.c           |   71 ++++++++++++++++++++++++++++++---------
 net/ceph/pagevec.c             |   18 +++++++---
 6 files changed, 72 insertions(+), 50 deletions(-)
