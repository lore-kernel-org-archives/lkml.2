Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2BAVbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:31:53 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44716 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab2BAVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:12 -0500
X-Sasl-enc: xQyYfaPFiHzcitmnCd7+n2jHu8O1+M6caNUtMXNehXBm 1328131151
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210044.949822019@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Carlos Maiolino <cmaiolino@redhat.com>,
        Jan Kara <jack@suse.cz>, Alex Elder <elder@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>
Subject: [12/89] xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9b025eb3a89e041bab6698e3858706be2385d692 upstream.

Commit b52a360b forgot to call xfs_iunlock() when it detected corrupted
symplink and bailed out. Fix it by jumping to 'out' instead of doing return.

CC: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alex Elder <elder@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_vnodeops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -131,7 +131,8 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		return XFS_ERROR(EFSCORRUPTED);
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto out;
 	}
 
 


