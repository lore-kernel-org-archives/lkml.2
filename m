Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab2DSVJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:09:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2DSVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:49 -0400
Message-Id: <20120419210612.310145115@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 14/59] cciss: Initialize scsi host max_sectors for tape drive support
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 395d287526bb60411ff37b19ad9dd38b58ba8732 upstream.

The default is too small (1024 blocks), use h->cciss_max_sectors (8192 blocks)
Without this change, if you try to set the block size of a tape drive above
512*1024, via "mt -f /dev/st0 setblk nnn" where nnn is greater than 524288,
it won't work right.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/cciss_scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -866,6 +866,7 @@ cciss_scsi_detect(ctlr_info_t *h)
 	sh->can_queue = cciss_tape_cmds;
 	sh->sg_tablesize = h->maxsgentries;
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
+	sh->max_sectors = h->cciss_max_sectors;
 
 	((struct cciss_scsi_adapter_data_t *) 
 		h->scsi_ctlr)->scsi_host = sh;


