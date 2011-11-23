Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab1KWArB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:47:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485Ab1KWAmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:09 2011
Message-Id: <20111123002409.001515351@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Alex Elder <aelder@sgi.com>
Subject: [47/53] xfs: Return -EIO when xfs_vn_getattr() failed
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -464,7 +464,7 @@ xfs_vn_getattr(
 	trace_xfs_getattr(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
 
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;


