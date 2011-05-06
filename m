Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab1EFAmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:42:07 -0400
Received: from kroah.org ([198.145.64.141]:37231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab1EFAZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.432340019@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [114/143] scsi_dh_emc: request flag cleanup
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 5738d4449c1baf05e8345684d12371f76296473d upstream.

blk_get_request sets the cmd_flags, so we should not and do not
need to set them. If we did set them to a different value then
it can cause a oops in the elevator code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -284,13 +284,11 @@ static struct request *get_req(struct sc
 	switch (cmd) {
 	case MODE_SELECT:
 		len = sizeof(short_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		rq->cmd[4] = len;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		rq->cmd[8] = len;
 		break;


