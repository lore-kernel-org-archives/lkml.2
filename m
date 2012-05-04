Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2EDSVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:21:21 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31421 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2EDSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:21:19 -0400
Subject: [PATCH] cciss: fix incorrect scsi status reporting
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Fri, 04 May 2012 13:21:14 -0500
Message-ID: <20120504182114.24883.40748.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Delete code which sets SCSI status incorrectly as it's already
been set correctly above this incorrect code.  Bug was introduced
by b0e15f6db1110319cb2e747e59e1200450a5ba3e
"cciss: fix typo that causes scsi status to be lost." in 2009.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-and-tested-by: Roel van Meer <roel.vanmeer@bokxing.nl>
Cc: stable@vger.kernel.org
---
 drivers/block/cciss_scsi.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

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

