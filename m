Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1BUUvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:51:08 -0500
Received: from cobra.newdream.net ([66.33.216.30]:53097 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1BUUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=TQ1QNyRiHRLaZoUTF8YbOjAxWyHqf+7JaxBv6xh9dz9Z+d2I
	AMnkuiROpuBP+gXgDo9+gt//kGByRHflbWrSFH1hQftrShH32A54HQ3K7kC5vDH7
	W6QhkbLrRtduqfVlt642O11/jggL/6u4g3cQvAegGrohtVH8d0WvkTf0aTI=
Date: Mon, 21 Feb 2011 12:52:35 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.38-rc6
Message-ID: <Pine.LNX.4.64.1102202115490.4468@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The main item here is a workaround for a regression caused by the dcache 
RCU stuff.  d_kill now clears d_parent prior to the release dentry op, 
which causes a NULL pointer dereference in the ceph code.  Nick said this 
should be easy enough to fix[1], but he's offline and it seems a bit late 
to futz with the core dcache code.  This patch basically just makes a copy 
of d_parent in the private d_fsdata struct.  We can revert it once the 
d_kill/d_parent thing gets fixed up, presumably during the next merge 
window.

There are also some error handling fixes and a fix for an possible 
infinite loop in the snapshot notification handler.

Thanks-
sage

[1] http://marc.info/?l=linux-fsdevel&m=129610552517424&w=2


Sage Weil (3):
      libceph: fix socket read error handling
      libceph: fix socket write error handling
      ceph: queue cap_snaps once per realm

Yehuda Sadeh (1):
      ceph: keep reference to parent inode on ceph_dentry

 fs/ceph/dir.c        |    5 +++-
 fs/ceph/snap.c       |   14 ++++++++---
 fs/ceph/super.h      |    1 +
 net/ceph/messenger.c |   62 +++++++++++++++++++++++++-------------------------
 4 files changed, 46 insertions(+), 36 deletions(-)
