Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1HAVEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:04:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14349 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HAVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:04:31 -0400
Date: Mon, 1 Aug 2011 23:04:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sage Weil <sage@newdream.net>
Subject: [PATCH][Resend] Remove unneeded version.h includes from include/
Message-ID: <alpine.LNX.2.00.1108012250420.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in include/.
This patch removes them.

When I last posted the patch, the ceph bit was ACK'ed by Sage Weil, so 
I've added that below.

The pwc-ioctl change generated quite a bit of discussion about V4L version 
numbers in general, but as far as I can tell, no concensus was reached on 
what the long term solution should be, so in the mean time I think we 
could start by just removing the unneeded include, which is why I'm 
resending the patch with that hunk still included.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Sage Weil <sage@newdream.net>
---
 include/linux/ceph/messenger.h |    1 -
 include/media/pwc-ioctl.h      |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index d7adf15..ca768ae 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -6,7 +6,6 @@
 #include <linux/net.h>
 #include <linux/radix-tree.h>
 #include <linux/uio.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 
 #include "types.h"
diff --git a/include/media/pwc-ioctl.h b/include/media/pwc-ioctl.h
index 0f19779..1ed1e61 100644
--- a/include/media/pwc-ioctl.h
+++ b/include/media/pwc-ioctl.h
@@ -53,7 +53,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/version.h>
 
 /* Enumeration of image sizes */
 #define PSZ_SQCIF	0x00
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

