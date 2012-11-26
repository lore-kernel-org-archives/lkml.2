Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2KZA2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 19:28:25 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:28131 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab2KZA2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 19:28:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMJADS3slB5LBva/2dsb2JhbABEhT+0ZIYEF3OCHgEBAQQBAjccEgYLEAgYMRQUEQM0iAwNvUgUjCyBEYMnA5NUgiyQRYMDgUsg
Date: Mon, 26 Nov 2012 11:28:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Message-ID: <20121126002814.GM32450@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353366267-15629-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs: revert commit bbdd6808 to fallocate UAPI

From: Dave Chinner <dchinner@redhat.com>

Commit bbdd6808 ("fs: reserve fallocate flag codepoint") changes the
fallocate(2) syscall interface. The flag that is reserved by this
commit is for functionality that has previously been NAKed on the
-fsdevel mailing list, and so exists out-of-tree.

The reserved syscall flag is completely undocumented, the commit
message doesn't tell us why the patches that use it exist out of
tree, or even why the flag needs to be in the kernel code and not
part of the out-of-tree patches. Further, the flag is not
implemented in any in-tree filesystems and probably never will be
due to the truck-sized security hole it opens up. Finally, we don't
change syscalls purely to support out-of-tree patches or kernel
modules.

The change to the syscall API was written and committed directly to
the ext4 tree by the ext4 maintainer, and merged through that tree
via the ext4 merge without review.  According to the commit message,
this was discussed at the Plumber's conference but no documentary
evidence of that discussion exists.  However, whether or not this
discussion took place is irrelevant as the proper venue for
discussion of this change is linux-fsdevel; discussions at a
conference are no substitute for a full airing of the change on the
appropriate mailing list.

The method of pushing of such a commit (i.e. written, committed and
pushed by a tree maintainer as part of a larger subsystem merge)
could be seen as designed to avoid review and discussion of a
controversial change that is likely to be NAKed. A long-term
subsystem maintainer should know better than to push changes in this
manner.

The lack of formal review and discussion for a syscall API change is
grounds for reverting patch, especially given the controversial
nature of the feature and the previous discussions and NAKs. The way
the change was pushed into mainline borders on an abuse of the trust
we place in maintainers and hence as a matter of principle this
change should be reverted.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Reason for resend:
- No response to orignal posting here:

	http://www.spinics.net/lists/linux-fsdevel/msg59937.html

 include/uapi/linux/falloc.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 990c4cc..8a7935f 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -3,7 +3,6 @@
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
-#define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
 
 
 #endif /* _UAPI_FALLOC_H_ */
