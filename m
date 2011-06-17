Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1FQQJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:09:01 -0400
Received: from relay3.sgi.com ([192.48.152.1]:60682 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932490Ab1FQQI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:08:58 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201106171608.p5HG8qno030243@stout.americas.sgi.com>
Date: Fri, 17 Jun 2011 11:08:52 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.0-rc4
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following two XFS changes for 3.0.

The first is a simple fix that flips the sign of an error return
value.

The second fixes a bug having to do with the order in which log and
data (or realtime) device cache flushes are issued.  This could lead
to data corruption when an external log was used.  Previously, we
avoided the problem by disabling barriers and issuing a warning
about that at mount time, but the recent barrier/FUA rework makes
that not work properly any more.  Fixing the flush ordering problem
also nicely eliminates the need a block of code.

Thanks.

					-Alex

The following changes since commit eb96c925152fc289311e5d7e956b919e9b60ab53:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-06-16 17:54:41 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Al Viro (1):
      xfs: fix ->mknod() return value on xfs_get_acl() failure

Christoph Hellwig (1):
      xfs: make log devices with write back caches work

 fs/xfs/linux-2.6/xfs_file.c  |   50 +++++++++++++++++----------
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   75 ------------------------------------------
 fs/xfs/xfs_log.c             |   11 +++++-
 4 files changed, 42 insertions(+), 96 deletions(-)
