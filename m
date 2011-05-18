Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1ERVHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:07:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50866 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1ERVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:07:29 -0400
Date: Wed, 18 May 2011 14:07:19 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ocfs2 and configfs fixes for 2.6.39-rc
Message-ID: <20110518210719.GE5898@noexit.corp.google.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus et al,
	Here are the last ocfs2 and configfs fixes for 2.6.39-rc.
These include a configfs crash and a compatibility regression in the
ocfs2 internal DLM.
	Please pull.


The following changes since commit 446cc6345d3de6571bdd0840f48aca441488a28d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs (2011-05-12 18:00:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

Joel Becker (2):
      configfs: Don't try to d_delete() negative dentries.
      configfs: Fix race between configfs_readdir() and configfs_d_iput()

Marcus Meissner (1):
      ocfs2: Initialize data_ac (might be used uninitialized)

Sunil Mushran (5):
      ocfs2/dlm: Use negotiated o2dlm protocol version
      ocfs2/cluster: Increase the live threshold for global heartbeat
      ocfs2/cluster: Heartbeat mismatch message improved
      ocfs2: Skip mount recovery for hard-ro mounts
      ocfs2/dlm: Target node death during resource migration leads to thread spin

Tristan Ye (1):
      ocfs2: skip existing hole when removing the last extent_rec in punching-hole codes.

 fs/configfs/dir.c            |   39 ++++++++++++++++++++++-----
 fs/ocfs2/cluster/heartbeat.c |   61 +++++++++++++++++++++++++++++------------
 fs/ocfs2/dir.c               |    2 +-
 fs/ocfs2/dlm/dlmdomain.c     |    3 +-
 fs/ocfs2/dlm/dlmmaster.c     |    3 ++
 fs/ocfs2/file.c              |   12 ++++++++
 fs/ocfs2/journal.c           |    3 ++
 7 files changed, 96 insertions(+), 27 deletions(-)
