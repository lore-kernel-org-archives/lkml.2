Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2IIXQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51299 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab2IIXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:33 -0400
Message-Id: <20120909224200.395448286@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Roel van Meer <roel.vanmeer@bokxing.nl>, Jens Axboe <axboe@kernel.dk>
Subject: [ 71/95] cciss: fix incorrect scsi status reporting
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/cciss_scsi.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index acda773..38aa6dd 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -763,16 +763,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 		{
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
-				if( ei->ScsiStatus)
-                		{
-#if 0
-                    			printk(KERN_WARNING "cciss: cmd %p "
-						"has SCSI Status = %x\n",
-						c, ei->ScsiStatus);
-#endif
-					cmd->result |= (ei->ScsiStatus << 1);
-                		}
-				else {  /* scsi status is zero??? How??? */
+				if (!ei->ScsiStatus) {
 					
 	/* Ordinarily, this case should never happen, but there is a bug
 	   in some released firmware revisions that allows it to happen


