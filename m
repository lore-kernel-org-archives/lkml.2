Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0IQNyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0IQNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:54:23 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 17 Sep 2010 14:59:41 +0100
Message-ID: <1284731981.2821.13.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following (very small!) patch,

Steve.

--------------------------------------------------------------------------------------------------
The following changes since commit 03a7ab083e4d619136d6f07ce70fa9de0bc436fc:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-09-16 12:59:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (1):
      GFS2: gfs2_logd should be using interruptible waits

 fs/gfs2/log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index cde1248..ac750bd 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -932,7 +932,7 @@ int gfs2_logd(void *data)
 
 		do {
 			prepare_to_wait(&sdp->sd_logd_waitq, &wait,
-					TASK_UNINTERRUPTIBLE);
+					TASK_INTERRUPTIBLE);
 			if (!gfs2_ail_flush_reqd(sdp) &&
 			    !gfs2_jrnl_flush_reqd(sdp) &&
 			    !kthread_should_stop())


