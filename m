Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2BAVtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:49:11 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48111 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059Ab2BAVIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:39 -0500
X-Sasl-enc: +2xfwuafUmZ6CC9cBInKrEErFGNKzi3GVgOJ665c73Yt 1328130518
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:38 2012
Message-Id: <20120201205738.277239733@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Carlos Maiolino <cmaiolino@redhat.com>,
        Jan Kara <jack@suse.cz>, Alex Elder <elder@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>
Subject: [09/65] xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -554,7 +554,8 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		return XFS_ERROR(EFSCORRUPTED);
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto out;
 	}
 
 


