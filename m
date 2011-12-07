Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab1LGQWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:22:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933579Ab1LGQWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161218.729790011@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:50 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, greg@kroah.com
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com, bpm@sgi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Alex Elder <aelder@sgi.com>
Subject: [048/104] xfs: Return -EIO when xfs_vn_getattr() failed
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

commit ed32201e65e15f3e6955cb84cbb544b08f81e5a5 upstream.

An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
Currently it returns EIO, not negative value, when it failed.  As a
result, the system call returns not negative value even though an
error occured. The stat(2), ls and mv commands cannot handle this
error and do not work correctly.

This patch fixes this bug, and returns -EIO, not EIO when an error
is detected in xfs_vn_getattr().

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -465,7 +465,7 @@ xfs_vn_getattr(
 	trace_xfs_getattr(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
 
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;


