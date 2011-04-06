Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1DFUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:15:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab1DFUPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:15:51 -0400
Date: Wed, 6 Apr 2011 13:15:50 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com,
        Dave Chinner <dchinner@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: remove unused 'bdi' variable in xfs_buf_readahead()
Message-ID: <alpine.LNX.2.00.1104061311450.5855@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of 

	fs/xfs/linux-2.6/xfs_buf.c: In function ¡xfs_buf_readahead¢:
	fs/xfs/linux-2.6/xfs_buf.c:660: warning: unused variable ¡bdi¢

The variable has been unused since 0e6e847ffe ("xfs: stop using the page 
cache to back the buffer cache")

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 596bb2c..d917146 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -657,8 +657,6 @@ xfs_buf_readahead(
 	xfs_off_t		ioff,
 	size_t			isize)
 {
-	struct backing_dev_info *bdi;
-
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-- 
1.7.3.1

