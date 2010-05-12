Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0ELXdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:33:44 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55312 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0ELXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:33:42 -0400
Date: Wed, 12 May 2010 16:36:48 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.34-final
Message-ID: <Pine.LNX.4.64.1005111258300.17789@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this final set of Ceph bugfixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

These fix a couple of locking errors, races, and ordering problems, and 
one bug that caused requests to hang indefinitely.  These close out the 
last of my open bugs resulting in client crashes.  There's also a subtle 
protocol fix that crops up when there's a transport error.

Thanks!
sage

---

Sage Weil (9):
      ceph: unregister bdi before kill_anon_super releases device name
      ceph: don't use writeback_control in writepages completion
      ceph: unregister osd request on failure
      ceph: fix open file counting on snapped inodes when mds returns no caps
      ceph: resubmit requests on pg mapping change (not just primary change)
      ceph: fix locking for waking session requests after reconnect
      ceph: zero unused message header, footer fields
      ceph: fix cap removal races
      ceph: preserve seq # on requeued messages after transient transport errors

 fs/ceph/addr.c       |    6 ------
 fs/ceph/caps.c       |   19 ++++++++++++-------
 fs/ceph/inode.c      |    4 ++++
 fs/ceph/mds_client.c |   34 +++++++++++++++++++---------------
 fs/ceph/messenger.c  |   17 +++++++++++++++--
 fs/ceph/messenger.h  |    1 +
 fs/ceph/osd_client.c |   26 ++++++++++++++++++++------
 fs/ceph/osd_client.h |    3 ++-
 fs/ceph/osdmap.c     |   29 ++++++++++++++++++++++++-----
 fs/ceph/osdmap.h     |    2 ++
 fs/ceph/rados.h      |    1 +
 fs/ceph/super.c      |   23 ++++++++++++++++-------
 12 files changed, 116 insertions(+), 49 deletions(-)
