Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab2ILXnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:43:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab2ILXna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:43:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Roel van Meer <roel.vanmeer@bokxing.nl>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 23/46] cciss: fix incorrect scsi status reporting
Date: Wed, 12 Sep 2012 16:39:13 -0700
Message-Id: <20120912233820.085711419@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/cciss_scsi.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -763,16 +763,7 @@ static void complete_scsi_command(Comman
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


