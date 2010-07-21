Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0GULgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:36:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55927 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338Ab0GULgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:36:50 -0400
Date: Wed, 21 Jul 2010 13:36:47 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH] fs/xfs: Remove dead CONFIG_XFS_DMAPI
Message-ID: <20100721113646.GA1054@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_XFS_DMAPI doesn't exist in Kconfig and is never defined anywhere
else, therefore removing all references for it from the source
code. Because XFS_DMAPI is never defined, XFS_DMAPI_STRING is always
an empty string. So we can remove all references to it.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 fs/xfs/linux-2.6/xfs_super.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.h b/fs/xfs/linux-2.6/xfs_super.h
index 519618e..1ef4a4d 100644
--- a/fs/xfs/linux-2.6/xfs_super.h
+++ b/fs/xfs/linux-2.6/xfs_super.h
@@ -56,12 +56,6 @@ extern void xfs_qm_exit(void);
 # define XFS_BIGFS_STRING
 #endif
 
-#ifdef CONFIG_XFS_DMAPI
-# define XFS_DMAPI_STRING	"dmapi support, "
-#else
-# define XFS_DMAPI_STRING
-#endif
-
 #ifdef DEBUG
 # define XFS_DBG_STRING		"debug"
 #else
@@ -72,7 +66,6 @@ extern void xfs_qm_exit(void);
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
 				XFS_BIGFS_STRING \
-				XFS_DMAPI_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
 struct xfs_inode;
-- 
1.7.0.4

