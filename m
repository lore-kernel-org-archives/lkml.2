Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab2HVQo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:44:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:48274 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab2HVQo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:44:56 -0400
Date: Wed, 22 Aug 2012 09:44:56 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.6-rc3
Message-ID: <alpine.DEB.2.00.1208220938560.26910@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes for -rc3 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Jim's fix closes a narrow race introduced with the msgr changes.  One fix 
resolves problems with debugfs initialization that Yan found when multiple 
client instances are created (e.g., two clusters mounted, or rbd + 
cephfs), another one fixes problems with mounting a nonexistent server 
subdirectory, and the last one fixes a divide by zero error from 
unsanitized ioctl input that Dan Carpenter found.

Thanks!
sage


----------------------------------------------------------------
Jim Schutt (1):
      libceph: avoid truncation due to racing banners

Sage Weil (3):
      libceph: delay debugfs initialization until we learn global_id
      ceph: tolerate (and warn on) extraneous dentry from mds
      ceph: avoid divide by zero in __validate_layout()

 fs/ceph/debugfs.c      |    1 +
 fs/ceph/inode.c        |   15 +++++++++----
 fs/ceph/ioctl.c        |    3 +-
 net/ceph/ceph_common.c |    1 -
 net/ceph/debugfs.c     |    4 +++
 net/ceph/messenger.c   |   11 ++++++++-
 net/ceph/mon_client.c  |   51 +++++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 72 insertions(+), 14 deletions(-)
