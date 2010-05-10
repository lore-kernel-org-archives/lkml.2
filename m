Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0EJXKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:10:35 -0400
Received: from kroah.org ([198.145.64.141]:45443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963Ab0EJW6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:43 2010
Message-Id: <20100510223542.943306737@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [95/98] [SCSI] Enable retries for SYNCRONIZE_CACHE commands to fix I/O error
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit c213e1407be6b04b144794399a91472e0ef92aec upstream.

Some arrays are giving I/O errors with ext3 filesystems when
SYNCHRONIZE_CACHE gets a UNIT_ATTENTION.  What is happening is that
these commands have no retries, so the UNIT_ATTENTION causes the
barrier to fail.  We should be enable retries here to clear any
transient error and allow the barrier to succeed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -971,6 +971,7 @@ static void sd_prepare_flush(struct requ
 {
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
+	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
 }


