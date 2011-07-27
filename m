Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1G0J6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab1G0J6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:58:38 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 27 Jul 2011 11:00:04 +0100
Message-ID: <1311760804.2801.13.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patch. Since it is only one
small patch I attached it below rather than posting it separately
as usual,

Steve.

--------------------------------------------------------------------
The following changes since commit e08dc1325feaf49eec392ee52feb2974ec3f5155:

  p9: avoid unused variable warning (2011-07-25 23:43:53 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (1):
      GFS2: Fix mount hang caused by certain access pattern to sysfs files

 fs/gfs2/ops_fstype.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--------------------------------------------------------------

>From 19237039919088781b4191a00bdc1284d8fea1dd Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 26 Jul 2011 09:15:45 +0100
Subject: [PATCH] GFS2: Fix mount hang caused by certain access pattern to sysfs files

Depending upon the order of userspace/kernel during the
mount process, this can result in a hang without the
_all version of the completion.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 516516e..3bc073a 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1018,13 +1018,13 @@ hostdata_error:
 		fsname++;
 	if (lm->lm_mount == NULL) {
 		fs_info(sdp, "Now mounting FS...\n");
-		complete(&sdp->sd_locking_init);
+		complete_all(&sdp->sd_locking_init);
 		return 0;
 	}
 	ret = lm->lm_mount(sdp, fsname);
 	if (ret == 0)
 		fs_info(sdp, "Joined cluster. Now mounting FS...\n");
-	complete(&sdp->sd_locking_init);
+	complete_all(&sdp->sd_locking_init);
 	return ret;
 }
 
-- 
1.7.4




