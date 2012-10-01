Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2JAXLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:11:13 -0400
Received: from 1wt.eu ([62.212.114.60]:35798 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab2JAXLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:11:11 -0400
Message-Id: <20121001225203.249985461@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 133/180] cciss: fix incorrect scsi status reporting
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

commit b0cf0b118c90477d1a6811f2cd2307f6a5578362 upstream.

Delete code which sets SCSI status incorrectly as it's already been set
correctly above this incorrect code.  The bug was introduced in 2009 by
commit b0e15f6db111 ("cciss: fix typo that causes scsi status to be
lost.")

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Roel van Meer <roel.vanmeer@bokxing.nl>
Tested-by: Roel van Meer <roel.vanmeer@bokxing.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/block/cciss_scsi.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 3315268..ad8e592 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -747,17 +747,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 		{
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
-				if( ei->ScsiStatus)
-                		{
-#if 0
-                    			printk(KERN_WARNING "cciss: cmd %p "
-					"has SCSI Status = %x\n",
-                        			cp,  
-						ei->ScsiStatus); 
-#endif
-					cmd->result |= (ei->ScsiStatus < 1);
-                		}
-				else {  /* scsi status is zero??? How??? */
+				if (!ei->ScsiStatus) {
 					
 	/* Ordinarily, this case should never happen, but there is a bug
 	   in some released firmware revisions that allows it to happen
-- 
1.7.2.1.45.g54fbc



